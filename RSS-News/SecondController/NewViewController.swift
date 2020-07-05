//
//  NewViewController.swift
//  RSS-News
//
//  Created by Азизбек on 04.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!

    var new: NewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        getNew(new: new)
    }
    
    func getNew(new: NewModel?) {
        guard let new = new else { return }
        topImageView.downloaded(from: new.imageURL, activityIndicator: activityIndicatior)
        titleLabel.text = new.title
        discriptionLabel.text = new.discription
    }
}

extension UIImageView {
    func downloadWith(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, activityIndicator: UIActivityIndicatorView) {
        contentMode = mode
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, activityIndicator: UIActivityIndicatorView) {
        guard let url = URL(string: link) else { return }
        downloadWith(url: url, activityIndicator: activityIndicator)
    }
}
