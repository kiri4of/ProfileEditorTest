
import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileNicknameLabel: UILabel!
    
    @IBOutlet weak var nameView: CustomView!
    
    @IBOutlet weak var genderView: CustomView!
    
    @IBOutlet weak var birthdayView: CustomView!
    
    @IBOutlet weak var phoneNumberView: CustomView!
    
    @IBOutlet weak var emailView: CustomView!
    
    @IBOutlet weak var userNameView: CustomView!
    
    private var textFieldManager: TextFieldManager!
    private var coreDataManager: CoreDataManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        setupProfileImageView()
        textFieldManager = TextFieldManager(viewController: self,
                                            nameView: nameView,
                                            genderView: genderView,
                                            birthdayView: birthdayView,
                                            phoneNumberView: phoneNumberView,
                                            emailView: emailView,
                                            userNameView: userNameView,
                                            profileNameLabel: profileNameLabel,
                                            profileNicknameLabel: profileNicknameLabel
        )
        coreDataManager = CoreDataManager()
        textFieldManager.setupAllFields()
        loadUserProfile()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
           if let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
               
               let keyboardHeight = keyboardFrame.height
               let bottomInset = view.safeAreaInsets.bottom
               let adjustedKeyboardHeight = keyboardHeight - bottomInset - 100
               
               UIView.animate(withDuration: duration) {
                   self.view.frame.origin.y = -adjustedKeyboardHeight
               }
           }
       }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           if let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
               
               UIView.animate(withDuration: duration) {
                   self.view.frame.origin.y = 0
               }
           }
       }
       
       deinit {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    private func saveUserProfile() {
        coreDataManager.saveOrUpdateUserProfile(
            fullName: nameView.inputTextField.text ?? "",
            gender: genderView.inputTextField.text ?? "",
            birthday: birthdayView.inputTextField.text ?? "",
            phoneNumber: phoneNumberView.inputTextField.text ?? "",
            email: emailView.inputTextField.text ?? "",
            userName: userNameView.inputTextField.text ?? "",
            profileName: profileNameLabel.text ?? "",
            profileNickname: profileNicknameLabel.text ?? "",
            profileImage: profileImageView.image
        )
    }
    
    private func loadUserProfile() {
        let profiles = coreDataManager.fetchUserProfiles()
        if let profile = profiles?.first {
            nameView.inputTextField.text = profile.fullName
            genderView.inputTextField.text = profile.gender
            birthdayView.inputTextField.text = profile.birthday
            phoneNumberView.inputTextField.text = profile.phoneNumber
            emailView.inputTextField.text = profile.email
            userNameView.inputTextField.text = profile.userName
            profileNameLabel.text = profile.profileName
            profileNicknameLabel.text = profile.profileNickname
            if let imageData = profile.profileImage {
                profileImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setupProfileImageView() {
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.black.cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        profileImageView.addGestureRecognizer(gesture)
        
        addCameraIcon()
    }
    
    private func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func addCameraIcon() {
        let cameraIconView = UIView()
        cameraIconView.backgroundColor = .black
        cameraIconView.layer.cornerRadius = 15
        cameraIconView.layer.masksToBounds = true
        
        let cameraIcon = UIImageView()
        let cameraImage = UIImage(systemName: "camera")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        cameraIcon.image = cameraImage
        
        cameraIconView.addSubview(cameraIcon)
        view.addSubview(cameraIconView)
        cameraIconView.translatesAutoresizingMaskIntoConstraints = false
        cameraIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraIconView.widthAnchor.constraint(equalToConstant: 30),
            cameraIconView.heightAnchor.constraint(equalToConstant: 30),
            cameraIconView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 0),
            cameraIconView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0),
            
            cameraIcon.centerXAnchor.constraint(equalTo: cameraIconView.centerXAnchor),
            cameraIcon.centerYAnchor.constraint(equalTo: cameraIconView.centerYAnchor),
            cameraIcon.widthAnchor.constraint(equalToConstant: 20),
            cameraIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        profileImageView.bringSubviewToFront(cameraIconView)
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        if textFieldManager.validateFields() {
            saveUserProfile()
        } else {
            let ac = UIAlertController(title: "Some fields are missing", message: " Please check and fill them", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true)

           guard let selectedImage = info[.editedImage] as? UIImage else { return }

           if let imageData = selectedImage.jpegData(compressionQuality: 1.0), imageData.count > 2 * 1024 * 1024 {
               let alert = UIAlertController(title: "Image Too Large",
                                             message: "Please select an image smaller than 2MB.",
                                             preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK",
                                             style: .default,
                                             handler: nil))
               present(alert, animated: true)
               return
           }

           self.profileImageView.image = selectedImage
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
