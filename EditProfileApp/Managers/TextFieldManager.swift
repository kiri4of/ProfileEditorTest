import UIKit

class TextFieldManager: NSObject {
    //MARK: - Propertis
    weak var viewController: UIViewController?
    weak var nameView: CustomView?
    weak var genderView: CustomView?
    weak var birthdayView: CustomView?
    weak var phoneNumberView: CustomView?
    weak var emailView: CustomView?
    weak var userNameView: CustomView?
    weak var profileNameLabel: UILabel?
    weak var profileNicknameLabel: UILabel?

    //MARK: - Init
    init(viewController: UIViewController, nameView: CustomView, genderView: CustomView, birthdayView: CustomView, phoneNumberView: CustomView, emailView: CustomView, userNameView: CustomView, profileNameLabel: UILabel, profileNicknameLabel: UILabel) {
        self.viewController = viewController
        self.nameView = nameView
        self.genderView = genderView
        self.birthdayView = birthdayView
        self.phoneNumberView = phoneNumberView
        self.emailView = emailView
        self.userNameView = userNameView
        self.profileNameLabel = profileNameLabel
        self.profileNicknameLabel = profileNicknameLabel
    }

    //MARK: - Setup Methods
    func setupAllFields() {
        setupNameField()
        setupGenderSelection()
        setupDatePicker()
        setupPhoneNumberField()
        setupUserNameField()
        setupEmailField()
        setupTitleLabels()
    }
    
    private func setupTitleLabels() {
        nameView?.titleLabel.text = "Full name"
        genderView?.titleLabel.text = "Gender"
        birthdayView?.titleLabel.text = "Birthday"
        phoneNumberView?.titleLabel.text = "Phone number"
        emailView?.titleLabel.text = "Email"
        userNameView?.titleLabel.text = "User name"
    }

    private func setupNameField() {
        nameView?.inputTextField.delegate = self
        nameView?.inputTextField.placeholder = "Your name"
    }

    func setupGenderSelection() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGenderField))
        genderView?.addGestureRecognizer(tapGesture)
        genderView?.isUserInteractionEnabled = true
        genderView?.inputTextField.delegate = self
        genderView?.inputTextField.placeholder = "Select your gender"
    }

    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)

        birthdayView?.inputTextField.inputView = datePicker
        birthdayView?.inputTextField.inputAccessoryView = toolbar

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        birthdayView?.inputTextField.placeholder = "Select your birth date"
        birthdayView?.inputTextField.delegate = self
    }

    func setupPhoneNumberField() {
        phoneNumberView?.inputTextField.delegate = self
        phoneNumberView?.inputTextField.keyboardType = .phonePad
        phoneNumberView?.inputTextField.placeholder = "(+XXX) XXXXXXXXXX"
    }
    
   func setupEmailField() {
       emailView?.inputTextField.keyboardType = .emailAddress
       emailView?.inputTextField.placeholder = "Your email"
    }

    func setupUserNameField() {
        userNameView?.inputTextField.delegate = self
        userNameView?.inputTextField.text = "@"
    }

    
    //MARK: - Validation Methods
    func validateFields() -> Bool {
        var allFieldsValid = true

        if let fullName = nameView?.inputTextField.text, fullName.isEmpty {
            setValidationState(for: nameView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: nameView?.inputTextField, valid: true)
        }
        
        if let gender = genderView?.inputTextField.text, gender.isEmpty {
            setValidationState(for: genderView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: genderView?.inputTextField, valid: true)
        }
        
        if let birthday = birthdayView?.inputTextField.text, birthday.isEmpty {
            setValidationState(for: birthdayView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: birthdayView?.inputTextField, valid: true)
        }

        if let phoneNumber = phoneNumberView?.inputTextField.text, phoneNumber.isEmpty {
            setValidationState(for: phoneNumberView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: phoneNumberView?.inputTextField, valid: true)
        }

        if let email = emailView?.inputTextField.text, email.isEmpty {
            setValidationState(for: emailView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: emailView?.inputTextField, valid: true)
        }

        if let userName = userNameView?.inputTextField.text, userName.count < 2 {
            setValidationState(for: userNameView?.inputTextField, valid: false)
            allFieldsValid = false
        } else {
            setValidationState(for: userNameView?.inputTextField, valid: true)
        }

        return allFieldsValid
    }

    private func setValidationState(for textField: UITextField?, valid: Bool) {
        guard let textField = textField else { return }
        if valid {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
        } else {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    //MARK: - Gender
    @objc private func didTapGenderField() {
        presentGenderSelection()
    }

    private func presentGenderSelection() {
        let actionSheet = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Male", style: .default, handler: { [weak self] _ in
            self?.genderView?.inputTextField.text = "Male"
            self?.setValidationState(for: self?.genderView?.inputTextField, valid: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Female", style: .default, handler: { [weak self] _ in
            self?.genderView?.inputTextField.text = "Female"
            self?.setValidationState(for: self?.genderView?.inputTextField, valid: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController?.present(actionSheet, animated: true)
    }

    //MARK: - Date Picker
    @objc private func donePressed() {
        if let datePicker = birthdayView?.inputTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            birthdayView?.inputTextField.text = dateFormatter.string(from: datePicker.date)
            checkAge()
        }
        viewController?.view.endEditing(true)
    }

    @objc private func cancelPressed() {
        viewController?.view.endEditing(true)
    }

    private func checkAge() {
        guard let text = birthdayView?.inputTextField.text, !text.isEmpty else {
            setValidationState(for: birthdayView?.inputTextField, valid: false)
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        if let birthDate = dateFormatter.date(from: text) {
            let age = calculateAge(from: birthDate)
            if age < 18 {
                let alert = UIAlertController(title: "Invalid Date", message: "You must be at least 18 years old.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController?.present(alert, animated: true, completion: nil)

                birthdayView?.inputTextField.text = nil
                setValidationState(for: birthdayView?.inputTextField, valid: false)
            } else {
                setValidationState(for: birthdayView?.inputTextField, valid: true)
            }
        } else {
            setValidationState(for: birthdayView?.inputTextField, valid: false)
        }
    }

    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthDate, to: Date())
        return components.year ?? 0
    }

    //MARK: - Phone Number Formatting
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let numericPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let countryCodeLength = 3
        let numberLength = 9

        var formattedNumber = ""

        if numericPhoneNumber.count > 0 {
            let countryCode = String(numericPhoneNumber.prefix(countryCodeLength))
            formattedNumber += "(+\(countryCode))"

            let remainingNumber = String(numericPhoneNumber.dropFirst(countryCodeLength))
            if remainingNumber.count > 0 {
                let phoneNumberPart = String(remainingNumber.prefix(numberLength))
                formattedNumber += " \(phoneNumberPart)"
            }
        }

        return formattedNumber
    }
}
//MARK: - DElegate
extension TextFieldManager: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdayView?.inputTextField {
            return true
        } else if textField == genderView?.inputTextField {
            presentGenderSelection()
            return false
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberView?.inputTextField {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if range.location <= 5 && string.isEmpty {
                textField.text = ""
            } else {
                textField.text = formatPhoneNumber(updatedText)
            }
            return false
        } else if textField == userNameView?.inputTextField {
            if range.location == 0 {
                return false
            }
            return true
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == birthdayView?.inputTextField {
            checkAge()
        } else if textField == nameView?.inputTextField {
            profileNameLabel?.text = textField.text
            setValidationState(for: textField, valid: !textField.text!.isEmpty)
        } else if textField == phoneNumberView?.inputTextField {
            setValidationState(for: textField, valid: !textField.text!.isEmpty)
        } else if textField == emailView?.inputTextField {
            setValidationState(for: textField, valid: isValidEmail(textField.text!))
        } else if textField == userNameView?.inputTextField {
            profileNicknameLabel?.text = textField.text
            setValidationState(for: textField, valid: textField.text!.count >= 2)
        }
    }
}
