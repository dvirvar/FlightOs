//
//  ViewController.swift
//  testTableView2
//
//  Created by Mimram on 5/28/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftSoup
import Lottie

class ViewController: UIViewController {
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    // FILTER:
    @IBAction func searchBar(_ sender: UITextField) {
        
        if !sender.text!.isEmpty{
            filterView.alpha = 1
            let type = sender.text!
            
            filtered = all.filter({ (x) -> Bool in
                x.cityHotel.contains(type)
            })
            
            filterTableView.reloadData()
        } else {
            filterView.alpha = 0
        }
    }
    
    var hotelDeals : [Hotels]!
    var flightBundles : [Hotels]!
    var israelHotels : [IsraelHotels]!
    var all : [Hotels]!
    var filtered : [Hotels]!
    var counterCr = 0
    var counterDS = 0
    var flagFilter = false
    let maxItemInRow = 4
    let maxRowInSection = 12
    let maxObjInArray = 16
    var hotelDealsFinished = false
    var flightBundlesFinished = false
    var israelHotelsFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotelDeals = []
        flightBundles = []
        israelHotels = []
        all = []
        filtered = []
        hotelDealsArrayFiller()
        flightBundlesArrayFiller()
        israelHotelsArrayFiller()
        
        // Refresher:
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        mainTableView.refreshControl = refresher
        
        let loadingPlane = LOTAnimationView.init(name: "planewhite")
        let skyBackground = LOTAnimationView.init(name: "sky")
        loadingPlane.play()
        skyBackground.play()
        loadingPlane.contentMode = .scaleAspectFit
        skyBackground.contentMode = .scaleAspectFill

        loadingPlane.loopAnimation = true
        skyBackground.loopAnimation = true
        refresher.addSubview(skyBackground)
        refresher.addSubview(loadingPlane)
        
        refresher.tintColor = .clear
        loadingPlane.frame = CGRect(x: 0, y: -90, width: mainTableView.frame.width, height: 250)
        skyBackground.translatesAutoresizingMaskIntoConstraints = true
        skyBackground.frame = CGRect(x: 0, y: -90, width: 420, height: 158)

        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        if hotelDealsFinished && flightBundlesFinished && israelHotelsFinished{
            mainTableView.refreshControl?.beginRefreshing()
            hotelDeals = []
            flightBundles = []
            israelHotels = []
            all = []
            hotelDealsArrayFiller()
            flightBundlesArrayFiller()
            israelHotelsArrayFiller()
            hotelDealsFinished = false
            flightBundlesFinished = false
            israelHotelsFinished = false
        }else{
            let alert = UIAlertController(title: "טוען חופשות...", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "אישור", style: .default))
            present(alert, animated: true) {
                self.mainTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func hotelDealsArrayFiller(){
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                let myUrl = try String(contentsOf: URL(string: "https://www.israir.co.il/Packages/Abroad.html")!, encoding: .utf8)
                let myParsedHtml = try SwiftSoup.parse(myUrl)
                let bundles = try myParsedHtml.select("div.category-content").select("div.templateCol").select("li.elemWrapper")
                
                for bundle in bundles{
                    let component = try bundle.attr("component")
                    if component == "promotions/packageMedium" && self.hotelDeals.count < self.maxObjInArray{
                        let inner = try bundle.select("div.inner")
                        let topBlock = try inner.select("div.top-block")
                        let urlChecker = try topBlock.select("img").attr("src")
                        let bottomBlock = try inner.select("div.bottom-block")
                        let blockHover = try inner.select("div.block-hover")
                        if urlChecker.contains("jpg"){
                            let imageHotel = "https://www.israir.co.il\(urlChecker)"
                            let textDiv = try topBlock.select("div.text")
                            let hotelName = try textDiv.select("h4").text()
                            let starIs = try textDiv.select("div.stars").select("i.icon-star-full")
                            var stars = 0
                            for _ in starIs.array() {
                                stars += 1
                            }
                            var starRatingPhoto = UIImage()
                            switch stars{
                            case 1:
                                starRatingPhoto = #imageLiteral(resourceName: "oneStar")
                            case 2:
                                starRatingPhoto = #imageLiteral(resourceName: "twostarr")
                            case 3:
                                starRatingPhoto = #imageLiteral(resourceName: "ThreeStar")
                            case 4:
                                starRatingPhoto = #imageLiteral(resourceName: "fourStar")
                            default:
                                starRatingPhoto = #imageLiteral(resourceName: "FiveStar")
                            }
                            let price = try textDiv.select("div.price").select("div.unit-price").text().split(separator: " ")[0]
                            
                            let nightsLi = try bottomBlock.select("ul.clearfix").select("li")
                            var nights = ""
                            for (index,element) in nightsLi.enumerated(){
                                if index == 1 {
                                    let nightsString = try element.text().split(separator: " ")
                                    nights = String(nightsString[0])
                                }
                            }
                            
                            let cityHotel = try blockHover.select("h3").text()
                            
                            let dparture = try blockHover.select("div.dparture")
                            let departureFrom = self.cityDateTime(element: dparture, string: "span.flight-takeoff")
                            let departureTo = self.cityDateTime(element: dparture, string: "span.flight-landing")
                            
                            let returnDiv = try blockHover.select("div.return")
                            let returnFrom = self.cityDateTime(element: returnDiv, string: "span.flight-takeoff")
                            let returnTo = self.cityDateTime(element: returnDiv, string: "span.flight-landing")
                            
                            let script = try bundle.select("script").array()[1].html()
                            
                            let shareLink = script.components(separatedBy: "shareLink: ")
                            let orderPage = self.urlExtractor(string: shareLink[1].trimmingCharacters(in: .whitespaces), startIndex: 1, endIndex: -4).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                            let orderPageUrl = try String(contentsOf: URL(string: orderPage)!, encoding: .utf8)
                            let parsedOrderHtml = try SwiftSoup.parse(orderPageUrl)
                            let topHeader = try parsedOrderHtml.select("header.top-header")
                            let priceFor2 = try parsedOrderHtml.select("div.total-price").text()
                            let orderBody = try parsedOrderHtml.select("div.order-body")
                            let description = try orderBody.select("div.right-part").select("div.text").text()
                            
                            let photosElements = try topHeader.select("div.swiper-container").select("div.swiper-wrapper").select("div.swiper-slide")
                            var photos = [String]()
                            for photoElement in photosElements{
                                var photoUrl = try photoElement.select("img").attr("src")
                                if !photoUrl.contains("http"){
                                    photoUrl = "https://www.israir.co.il\(photoUrl)"
                                }
                                photos.append(photoUrl)
                            }
                            
                            let hotelDeal = Hotels(hotelName: hotelName, cityHotel: cityHotel, priceBundle: String(price), priceFor2People: priceFor2, ratingStar: starRatingPhoto, numOfNight: nights, departureCityFrom: departureFrom.city, departureDateFrom: departureFrom.date, departureTimeFrom: departureFrom.time, departureCityTo: departureTo.city, departureDateTo: departureTo.date, departureTimeTo: departureTo.time, returnCityFrom: returnFrom.city, returnDateFrom: returnFrom.date, returnTimeFrom: returnFrom.time, returnCityTo: returnTo.city,  returnDateTo: returnTo.date, returnTimeTo: returnTo.time, typeof: "טיסה + מלון", description: description, imageHotel: imageHotel, photos: photos)
                            self.hotelDeals.append(hotelDeal)
                            self.all.append(hotelDeal)
                            DispatchQueue.main.async {
                                self.mainTableView.reloadData()
                                self.filterTableView.reloadData()
                            }
                        }//urlChecker
                    }//if component + maxObjInArray
                }//bundle
                self.hotelDealsFinished = true
            }catch{
            }
            
        }//Dispatch
    }
    
    func flightBundlesArrayFiller() {
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                let myUrlString = try String(contentsOf: URL(string: "https://www.israir.co.il/Flights/Abroad.html")!, encoding: .utf8)
                let parsedHtml = try SwiftSoup.parse(myUrlString)
                let flights: Elements = try parsedHtml.select("div.category-content").select("div.templateCol").select("li.elemWrapper")
                
                for flight in flights{
                    let component = try flight.attr("component")
                    if component == "promotions/packageMedium" && self.flightBundles.count < self.maxObjInArray{
                        let inner = try flight.select("div.inner")
                        let blockHover = try inner.select("div.block-hover")
                        let dparture = try blockHover.select("div.dparture")
                        let returnFlight = try blockHover.select("div.return")
                        let imgSrc = try inner.select("img").attr("src")
                        let flightImage = "https://www.israir.co.il\(imgSrc)"
                        let price = try inner.select("div.text").select("div.price").select("div.unit-price").text().split(separator: " ")[0]
                        let countryName = try blockHover.select("h3").text()
                        let departureSCandCityFrom = try dparture.select("span.flight-takeoff").select("div.city").text().split(separator: " ")
                        var departureCityFrom = ""
                        for string in departureSCandCityFrom{
                            departureCityFrom += String(string) + " "
                        }
                        
                        let departureDateFrom = self.urlExtractor(string: try dparture.select("span.flight-takeoff").select("div.date").text(), startIndex: 0, endIndex: -5)
                        let departureTimeFrom = try dparture.select("span.flight-takeoff").select("div.date").select("span").text()
                        let departureSCandCityTo = try dparture.select("span.flight-landing").select("div.city").text().split(separator: " ")
                        
                        var departureCityTo = ""
                        for string in departureSCandCityTo{
                            departureCityTo += String(string) + " "
                        }
                        
                        let departureDateTo = self.urlExtractor(string: try dparture.select("span.flight-landing").select("div.date").text(), startIndex: 0, endIndex: -5)
                        let departureTimeTo = try dparture.select("span.flight-landing").select("div.date").select("span").text()
                        
                        let returnDateFrom = self.urlExtractor(string: try returnFlight.select("span.flight-takeoff").select("div.date").text(), startIndex: 0, endIndex: -5)
                        let returnTimeFrom = try returnFlight.select("span.flight-takeoff").select("div.date").select("span").text()
                        let returnSCandCityFrom = try returnFlight.select("span.flight-takeoff").select("div.city").text().split(separator: " ")
                        
                        var returnCityFrom = ""
                        for string in returnSCandCityFrom{
                            returnCityFrom += String(string) + " "
                        }
                        
                        let returnSCandCityTo = try returnFlight.select("span.flight-landing").select("div.city").text().split(separator: " ")
                        
                        var returnCityTo = ""
                        for string in returnSCandCityTo{
                            returnCityTo += String(string) + " "
                        }
                        
                        let returnDateTo = self.urlExtractor(string: try returnFlight.select("span.flight-landing").select("div.date").text(), startIndex: 0, endIndex: -5)
                        let returnTimeTo = try returnFlight.select("span.flight-landing").select("div.date").select("span").text()
                        
                        let flightBundle = Hotels(hotelName: "", cityHotel: countryName, priceBundle: String(price), priceFor2People: "", ratingStar: UIImage(), numOfNight: "", departureCityFrom: departureCityFrom, departureDateFrom: departureDateFrom, departureTimeFrom: departureTimeFrom, departureCityTo: departureCityTo, departureDateTo: departureDateTo, departureTimeTo: departureTimeTo, returnCityFrom: returnCityFrom, returnDateFrom: returnDateFrom, returnTimeFrom: returnTimeFrom, returnCityTo: returnCityTo, returnDateTo: returnDateTo, returnTimeTo: returnTimeTo, typeof: "טיסה", description: "", imageHotel: flightImage, photos: [])
                        self.flightBundles.append(flightBundle)
                        self.all.append(flightBundle)
                        
                        DispatchQueue.main.async {
                            self.mainTableView.reloadData()
                            self.filterTableView.reloadData()
                        }
                    }//if component + maxObjInArray
                }//for flight
                self.flightBundlesFinished = true
            }catch{
            }
            
        }//Dispatch
    }
    
    func israelHotelsArrayFiller() {
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                let myUrlString = try String(contentsOf: URL(string: "https://www.wallatours.co.il/israel/hotels.aspx")!, encoding: .utf8)
                let parsedHtml = try SwiftSoup.parse(myUrlString)
                let hotels: Elements = try parsedHtml.select("div.base-master").select("div.mid").select("div.dl_item")
                for hotel in hotels{
                    if self.israelHotels.count < self.maxObjInArray{
                        let imDiv = try hotel.select("div.im")
                        let infoPage = try imDiv.select("a").attr("href") // t אחרי הלחיצה
                        let imageHotel = try imDiv.select("img").attr("src").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let dates = try imDiv.select("div.box-white").select("span").text().components(separatedBy: " - ")
                        let returnDate = dates[0]
                        let checkinDate = dates[1]
                        let hotelName = try hotel.select("div.content").select("span.title").text()
                        let price = try hotel.select("div.price").select("div.amount").text()
                        let infoPageUrl = try String(contentsOf: URL(string: infoPage)!, encoding: .utf8)
                        let parsedInfoPage = try SwiftSoup.parse(infoPageUrl)
                        let packageContent = try parsedInfoPage.select("div.PackageContent")
                        var photos = [String]()
                        let photo = try packageContent.select("div.frame_filter_gray").select("img").attr("src")
                        photos.append(photo)
                        let details = try packageContent.select("div.details")
                        let description = try details.select("div.TextArea").text()
                        let photosUrl = try details.select("div.gallery").select("ul").select("li.hotelgallery").select("img")
                        var imageFlag = false // להתחיל מהאינקדס השני של התמונה ולא ה0 ! 
                        for url in photosUrl{
                            if imageFlag{
                                photos.append(try url.attr("src"))
                            }else{
                                imageFlag = true
                            }
                        }
                        
                        self.israelHotels.append(IsraelHotels(hotelName: hotelName, priceBundle: price, checkinDate: checkinDate, returnDate: returnDate, description: description, mainImage: imageHotel!, photos: photos))
                        DispatchQueue.main.async {
                            self.mainTableView.reloadData()
                        }
                    }//if maxObjInArray
                }//hotel
                self.israelHotelsFinished = true
            }catch{
            }
            
        }//Dispatch
    }
    
    func urlExtractor(string:String, startIndex:Int, endIndex:Int)->String{
        let start = string.index(string.startIndex, offsetBy: startIndex)
        let end = string.index(string.endIndex, offsetBy: endIndex)
        let range = start..<end
        let mySubstring = string[range]
        return String(mySubstring)
    }
    
    func cityDateTime(element:Elements,string:String) -> (city:String,date:String,time:String) {
        do{
            let newElement = try element.select(string)
            let city = try newElement.select("div.city").text()
            let date = urlExtractor(string: try newElement.select("div.date").text(), startIndex: 0, endIndex: -5)
            let time = try newElement.select("span.time").text()
            return (city,date,time)
        }catch{
        }
        return ("","","")
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tableViewRow = collectionView.tag / 3
        if collectionView.tag % 3 == 0{
            let fullRows = hotelDeals.count / maxItemInRow

            if fullRows > tableViewRow{
                return maxItemInRow
            }else if fullRows == tableViewRow{
                return hotelDeals.count % maxItemInRow
            }else{
                return 0
            }
            
        } else if collectionView.tag % 3 == 1 {
            let fullRows = flightBundles.count / maxItemInRow
            
            if fullRows > tableViewRow{
                return maxItemInRow
            }else if fullRows == tableViewRow{
                return flightBundles.count % maxItemInRow
            }else{
                return 0
            }
            
        } else {
            let fullRows = israelHotels.count / maxItemInRow
            
            if fullRows > tableViewRow{
                return maxItemInRow
            }else if fullRows == tableViewRow{
                return israelHotels.count % maxItemInRow
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        counterCr = collectionView.tag/3
        
        if collectionView.tag % 3 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fccell", for: indexPath) as! FirstCollectionViewCell
            
            let hotel = hotelDeals[indexPath.row + (counterCr * maxItemInRow)]
            cell.hotelName.text = hotel.hotelName
            cell.cityHotel.text = hotel.cityHotel
            cell.priceBundle.text = hotel.priceBundle
            cell.oldPrice.text = hotel.priceFor2People
            cell.ratingStarImg.image = hotel.ratingStar
            cell.numOfNight.text = hotel.numOfNight
            
            cell.departureCityFrom.text = hotel.departureCityFrom
            cell.departureDateFrom.text = hotel.departureDateFrom
            cell.departureTimeFrom.text = hotel.departureTimeFrom
            
            cell.departureCityTo.text = hotel.departureCityTo
            cell.departureDateTo.text = hotel.departureDateTo
            cell.departureTimeTo.text = hotel.departureTimeTo
            
            cell.returnCityFrom.text = hotel.returnCityFrom
            cell.returnDateFrom.text = hotel.returnDateFrom
            cell.returnTimeFrom.text = hotel.returnTimeFrom
            
            cell.returnCityTo.text = hotel.returnCityTo
            cell.returnDateTo.text = hotel.returnDateTo
            cell.returnTimeTo.text = hotel.returnTimeTo
            
            cell.hotelPhoto.sd_setImage(with: URL(string: hotel.imageHotel))
            
            return cell
        } else if collectionView.tag % 3 == 1 {
            
            let flightIndex = flightBundles[indexPath.row + (counterCr * maxItemInRow)]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sccell", for: indexPath) as! SecoundCollectionViewCell
            cell.countryLabel.text = flightIndex.cityHotel
            cell.priceLabel.text = flightIndex.priceBundle
            cell.mainImage.sd_setImage(with: URL(string: flightIndex.imageHotel))
            return cell
            
        } else {
            
            let israelIndex = israelHotels[indexPath.row + (counterCr * maxItemInRow)]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tccell", for: indexPath) as! ThirdCollectionViewCell
            cell.textLabel.text = israelIndex.hotelName
            cell.priceLabel.text = israelIndex.priceBundle
            cell.mainImage.sd_setImage(with: URL(string: israelIndex.mainImage))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        counterDS = collectionView.tag/3
        let myRow = indexPath.row + (counterDS * maxItemInRow)
        flagFilter = false
        if collectionView.tag % 3 == 0 {
            performSegue(withIdentifier: "masterdeatilshotel", sender: myRow)
        } else if collectionView.tag % 3 == 1 {
            performSegue(withIdentifier: "materdeatilsflight", sender: myRow)
        } else if collectionView.tag % 3 == 2{
            performSegue(withIdentifier: "masterdataisrael", sender: myRow)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destintion = segue.destination as? HotelViewController{
            let selectedIndexpath = sender as? Int
            if !flagFilter{
                destintion.hotel = hotelDeals[(selectedIndexpath)!]
            }else{
                destintion.hotel = filtered[selectedIndexpath!]
            }
        }
        
        if let destination = segue.destination as? FlightsViewController {
            let selectedIndexpath = sender as? Int
            if !flagFilter{
                destination.flights = flightBundles[(selectedIndexpath)!]
            }else{
                destination.flights = filtered[selectedIndexpath!]
            }
        }
        
        if let destination = segue.destination as? IsraelViewController {
            let selectedIndexpath = sender as? Int
            if !flagFilter{
                destination.israel = israelHotels[(selectedIndexpath)!]
            }
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 10 {
            return maxRowInSection
        } else if tableView.tag == 20{
            return filtered.count
        } else {
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 3 == 0  && tableView.tag == 10{
            return 240.0
        } else if indexPath.row % 3 == 1 && tableView.tag == 10{
            return 179.0
        } else if indexPath.row % 3 == 2 && tableView.tag == 10{
            return 101
        } else {
            return 268
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 3 == 0 && tableView.tag == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ftcell", for: indexPath) as! FirstTableViewCell
            cell.firstCollectionView.reloadData()
            return cell
        } else if indexPath.row % 3 == 1 && tableView.tag == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "stcell", for: indexPath) as! SecondTableViewCell
            cell.secondCollectionView.reloadData()
            return cell
        } else if indexPath.row % 3 == 2 && tableView.tag == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ttcell", for: indexPath) as! ThirdTableViewCell
            cell.thirdCollectionView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filtercell", for: indexPath) as! FilterTableViewCell
            cell.hotelname.text = filtered[indexPath.row].hotelName
            cell.countryHotel.text = filtered[indexPath.row].cityHotel
            cell.watchingNow.text = "צופים כעת: \(arc4random_uniform(10))"
            cell.price.text = filtered[indexPath.row].priceBundle
            cell.typeOfVaction.text = filtered[indexPath.row].typeof
            cell.imagehotel.sd_setImage(with: URL(string: filtered[indexPath.row].imageHotel))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let firsttableviewcell = cell as? FirstTableViewCell {
            firsttableviewcell.setCollectionDatasourceDelege(self, forRow: indexPath.row)
        }
        if let secondtableviewcell = cell as? SecondTableViewCell {
            secondtableviewcell.setCollectionDatasourceDelege(self, forRow: indexPath.row)
        }
        if let thirdtableviewcell = cell as? ThirdTableViewCell {
            thirdtableviewcell.setCollectionDatasourceDelege(self, forRow: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flagFilter = true
        if tableView.tag == 20 && filtered[indexPath.row].typeof == "טיסה + מלון"{
            performSegue(withIdentifier: "masterdeatilshotel", sender: indexPath.row)
        }else if tableView.tag == 20 && filtered[indexPath.row].typeof == "טיסה"{
            performSegue(withIdentifier: "materdeatilsflight", sender: indexPath.row)
        }
    }
}


