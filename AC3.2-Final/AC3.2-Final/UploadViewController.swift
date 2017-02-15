//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Annie Tung on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos
import MobileCoreServices

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadComment: UITextField!
    var databaseReference: FIRDatabaseReference!
    var storageReference: FIRStorageReference!
    var picker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseReference = FIRDatabase.database().reference()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openLibrary))
        uploadImage.isUserInteractionEnabled = true
        uploadImage.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        let linkRef = self.databaseReference.child("posts").childByAutoId()
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://ac-32-final.appspot.com")
        let spaceRef = storageRef.child("images/\(linkRef.key)")
        
        if let image = uploadImage.image {
            if let jpeg = UIImageJPEGRepresentation(image, 0.5) {
                
                let metadata = FIRStorageMetadata()
                metadata.cacheControl = "public,max-age=300";
                metadata.contentType = "image/jpeg";
                let _ = spaceRef.put(jpeg, metadata: metadata, completion: { (metadata, error) in
                    guard metadata != nil else {
                        print("upload error")
                        return
                    }
                })
                let feed = Feed(key: linkRef.key, uid: (FIRAuth.auth()?.currentUser?.uid)!, comment: self.uploadComment.text!)
                let dict = feed.asDictionary
                linkRef.setValue(dict, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                        let alert = UIAlertController(title: "Upload failed!", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        print(reference)
                        let alert = UIAlertController(title: "Photo uploaded!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [String(kUTTypeImage)]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Error choosing image to display")
            return
        }
        uploadImage.contentMode = .scaleAspectFill
        uploadImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
