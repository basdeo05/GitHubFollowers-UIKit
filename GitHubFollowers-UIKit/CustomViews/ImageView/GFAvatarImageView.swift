//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/31/24.
//

import UIKit

class GFAvatarImageView: UIImageView {

    //cache to check if image is in cache or to se the image in the cache
    let cache = NetworkManager.shared.cache
    
    //placeholder image to know if something went wrong
    let placeholderImage = UIImage(named: "avatar-placeholder")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        
        layer.cornerRadius = 10
        
        //without this the layer corner radies will be round but the image will be square
        //adding will also round the image corner radius
        clipsToBounds = true
        
        image = placeholderImage
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Downloads the image
    //Check cache first, and if is in cache use the cache iamge
    //if not in cache, perform network call and save it in cache
    //If any errors, just display the placeholder image
    func downloadImage(string: String){
        
        let cacheKey = NSString(string: string)
        if let image = cache.object(forKey: cacheKey){
            self.image = image
            return
        }
        
        
        guard let url = URL(string: string) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else {
                return
            }
            
            if error != nil {
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
    }
}
