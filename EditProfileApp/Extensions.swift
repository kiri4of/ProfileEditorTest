
import UIKit

extension UIView {
    func loadViewFromNib<T: UIView>(viewType: T.Type) -> UIView? {
        let nibName = String(describing: viewType)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}

