//
//  ScannerViewController.swift
//  Group Project
//
//  Created by Justin Joerg on 4/9/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private var barcodeScanned: String = ""
    private var blnToggleCamera: Bool = false
    override func viewDidLoad() {
        //places the first contact into the text fields at start of app
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if(session.canAddInput(videoInput)){
            session.addInput(videoInput)
        }else{
            scanningNotPossible()
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput))
        {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self,queue: dispatch_get_main_queue())
            
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code]
            
            
        }else{
            scanningNotPossible()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scanningNotPossible()
    {
        let alert = UIAlertController(title: "Can't Scan", message: "Let's try a device equipped with a camera", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        session = nil
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        
        if let barcodeData = metadataObjects.first{
            
            
            let barcodeReadable =  barcodeData as? AVMetadataMachineReadableCodeObject
            if let readableCode = barcodeReadable{
                barcodeDetected(readableCode.stringValue)
                
            }
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            
            blnToggleCamera = false
            
            
            session.stopRunning()
            
            navigationItem.rightBarButtonItem = nil
            
            previewLayer.removeFromSuperlayer()
            
          
        }
    }
    
    func barcodeDetected(code: String)
    {
        
        barcodeScanned = code
        
        performSegueWithIdentifier("segItemDetails", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segItemDetails"
        {
            let destVC = segue.destinationViewController as! ItemDetailsViewController
            destVC.itemBarcode = barcodeScanned
        }
    }
    
    func cancelTapped()
    {
        blnToggleCamera = false
        
        
        session.stopRunning()
        
        navigationItem.rightBarButtonItem = nil
        
        previewLayer.removeFromSuperlayer()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func scanItem(sender: AnyObject) {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelTapped))
        
        

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        blnToggleCamera = true
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
        
        
        
    }

    
    
    
    
    
    
    

    
}
