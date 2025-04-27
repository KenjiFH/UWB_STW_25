//
//  AVCaptureViewController.swift
//  homePageTest
//
//  Created by Kenji Fahselt on 4/26/25.
//

import SwiftUI
import AVFoundation


struct BarcodeScannerView: View{
    @State private var isScanning = false
    @State private var scannedCode: String?
    
    @State private var isShowingResult = false
    

   
    // Adjust the `[String]` type to match the type of your array elements.

    // 1. Load the existing array (or create an empty one if none)
   

    
    var body: some View {
        
        VStack {
            Text("Scan a Barcode")
                .font(.title)
                .padding()
            
            CameraPreviewView(isScanning: $isScanning, scannedCode: $scannedCode)
                .frame(height: 400)
            
            if let scannedCode = scannedCode {
                Text("Scanned Code: \(scannedCode)")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            isScanning = true
        }
        .onChange(of: scannedCode) { newValue in
              if newValue != nil {
                  
                  isShowingResult = true
                  isScanning = false
              }
            
         
                      }
          
          .sheet(isPresented: $isShowingResult) {
              
              
              if let scannedCode = scannedCode {
               
                  ScanResultView(code: scannedCode)
              }
          }
    }
}

struct CameraPreviewView: UIViewControllerRepresentable {
    @Binding var isScanning: Bool
    @Binding var scannedCode: String?
    
    func makeUIViewController(context: Context) -> AVCaptureViewController {
        let viewController = AVCaptureViewController(isScanning: $isScanning, scannedCode: $scannedCode)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: AVCaptureViewController, context: Context) {
        // You can update the view here if needed
    }
}

class AVCaptureViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @Binding var isScanning: Bool
    @Binding var scannedCode: String?
    
    @EnvironmentObject var UPCoutput : ViewMetaDataController
    
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // Custom initializer
    init(isScanning: Binding<Bool>, scannedCode: Binding<String?>) {
        _isScanning = isScanning
        _scannedCode = scannedCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        
        // Set up the camera input
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoDeviceInput: AVCaptureDeviceInput
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoDeviceInput)) {
            captureSession.addInput(videoDeviceInput)
        } else {
            return
        }
        
        // Set up the metadata output (for barcode scanning)
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            // Set the delegate and use the default dispatch queue for processing
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce, .code128, .pdf417, .qr]
        } else {
            return
        }
        
        // Preview layer to show the camera feed
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start the capture session
        captureSession.startRunning()
    }
    
    // Delegate method to handle the barcode detection
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // Optionally vibrate on scan
            scannedCode = stringValue // Set scanned code
           
           // UPCoutput.UPC = stringValue
            
            
            
           
            // Stop scanning after one successful scan
            captureSession.stopRunning()
            isScanning = false
        }
    }
    
    deinit {
        captureSession?.stopRunning()
    }
}







