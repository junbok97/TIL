import UIKit
import RxSwift

final class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField
    
    func bind(_ viewModel: PostsViewModel) {
        viewModel.postTableViewCellInput
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bind(_ viewModel:PostItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.detailsLabel.text = viewModel.subtitle
    }
    
}
