
import UIKit
@IBDesignable
class CustomView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    private func commonSetup() {
        guard let view = self.loadViewFromNib(viewType: CustomView.self) else {return}
        view.frame = self.bounds
        self.addSubview(view)
        setupView()
    }
    
    private func setupView() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10.0

        titleLabel.textColor = .lightGray
        inputTextField.textColor = UIColor.black
    }
    
    func configurateView(title: String, text: String) {
        self.titleLabel.text = title
        self.inputTextField.text = text
    }
}
