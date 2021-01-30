//
//  CellBuilder.swift
//  News
//
//  Created by Alina Petrovskaya on 20.01.2021.
//

import UIKit



struct ArticleBrain {
    
    enum TypeForGetDate {
        case dateForPreviewNews
        case dateForFilterButton
    }
    
    var images: [String : Data] = [:]
    var dbManager = DBManager()
    
    mutating func buildCellForArticleTable(cell: ReusableArticleTableViewCell?, contentForCell: Article?) -> ReusableArticleTableViewCell {
        
        let dateString = convertDateIntoString(date: contentForCell?.publishedAt, type: .dateForPreviewNews)
        
        if let imageURL = contentForCell?.urlToImage { //set image for cell
            if let imageData = images[imageURL] {
                let image = UIImage(data: imageData)
                cell?.previewImage.image = image ?? #imageLiteral(resourceName: "default")
            }
        }
        
        func getIndexForReloadRow() {
            
        }
        
        let isSaved = dbManager.isArticleSaved(urlString: contentForCell?.urlString)
        cell?.updateUI(title: contentForCell?.title,
                       date: dateString,
                       sourceName: contentForCell?.source.name,
                       urlString: contentForCell?.urlString,
                       content: contentForCell?.content,
                       articleDescription: contentForCell?.articleDescription,
                       isSaved: isSaved)
        
        return cell ?? ReusableArticleTableViewCell()
    }
    
    func getDataForArticleDetail(contentForArticleDetail: Article) -> DataForArticle {
        
        var dataForDetailVC: DataForArticle  = (image: #imageLiteral(resourceName: "default"),
                                                title: contentForArticleDetail.title,
                                                sourceName: contentForArticleDetail.source.name,
                                                urlString: contentForArticleDetail.urlString,
                                                content: contentForArticleDetail.content,
                                                articleDescription: contentForArticleDetail.articleDescription)
        
        guard let image = contentForArticleDetail.urlToImage else {
            return dataForDetailVC
        }
        
        if let imageData = images[image] {
            dataForDetailVC.image =  UIImage(data: imageData) ?? #imageLiteral(resourceName: "default")
        }
        
        return dataForDetailVC
    }
    
    
    func getPreviousDate() -> Date {
        let dateFormatter = DateFormatter()
        var dayComponent  = DateComponents()
        
        dayComponent.day         = -1
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        if let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            return previousDay
        }
        
        return Date()
    }
    
    func returnRowIndex(articleList: [Article]?, urlString: String?) -> Int? {
        
        guard let articles = articleList else { return nil }
        
        var index = 0
        
        for item in articles {
            
            if item.urlString == urlString {
                break
            } else {
                index += 1
            }
        }
        
        return index
    }
    
    func convertDateIntoString(date: Date?, type: TypeForGetDate) -> String {
        guard let safeDate = date else { return "no Date" }
        
        let dateFormatter  = DateFormatter()
        
        switch type {
        case .dateForPreviewNews:
            dateFormatter.dateFormat = "MMM d, yyyy • HH:mm"
            return dateFormatter.string(from: safeDate)
            
        case .dateForFilterButton:
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: safeDate)
        }
    }
    
}