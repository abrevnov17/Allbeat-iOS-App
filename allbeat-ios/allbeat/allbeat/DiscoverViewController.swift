//
//  DiscoverViewController.siwft
//  allbeat
//
//  Created by Anatoly Brevnov on 8/28/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblMain: UITableView!
    
    //basically our data array
    var data: [DiscoverCellModel] = []
    //provides last clicked cell index
    var lastClicked = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if (Allbeat.isLoggedIn() != true){
            self.performSegue(withIdentifier: "auth", sender: self)
        }
        
        /*
                   Allbeat.aggregateChannels { (channels: Array<String>?) in
                
                print("here are the channels: ")
                print(channels)
                
                for channel in channels! {
                    
                   // self.data.append(DiscoverCellModel(title: channel, image: UIImage(named:channel)!))
                     self.data.append(DiscoverCellModel(title: channel, image:  #imageLiteral(resourceName: "edm")))
                    self.tblMain.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
                    
                    /*
                     
                     Allbeat.getChannelProPic(channelID: channel) { (url: String?) in
                     if (url != nil) {
                     let httpsReference = FIRStorage.storage().reference(forURL: url!)
                     print("aasdfasdfasdf")
                     print("here is the channel1:" + channel)
                     httpsReference.data(withMaxSize: (1 * 1024 * 1024), completion: { (data, error) in
                     if (error != nil) {
                     // Uh-oh, an error occurred!
                     } else {
                     self.data.append(DiscoverCellModel(title: channel, image: UIImage(data: data!)!))
                     }
                     })
                     
                     }
                     
                     else {
                     print("here is the channel2:" + channel)
                     }
                     
                     
                     
                     
                     
                     }
                     */
                    
                    
                }
            }
 
 */
        
        self.data.append(DiscoverCellModel(title: "edm", image:  #imageLiteral(resourceName: "edm")))
        self.data.append(DiscoverCellModel(title: "pop", image: #imageLiteral(resourceName: "pop")))
        self.data.append(DiscoverCellModel(title: "rap", image:  #imageLiteral(resourceName: "rap.jpg")))
        self.data.append(DiscoverCellModel(title: "alternative", image:  #imageLiteral(resourceName: "alternative2.jpg")))
        self.data.append(DiscoverCellModel(title: "country", image:  #imageLiteral(resourceName: "country.jpg")))
        self.data.append(DiscoverCellModel(title: "rock", image: #imageLiteral(resourceName: "rock.jpg")))
        self.data.append(DiscoverCellModel(title: "reggae", image: #imageLiteral(resourceName: "reggae.jpg")))
        self.data.append(DiscoverCellModel(title: "r&b", image: #imageLiteral(resourceName: "r&b.jpg")))
        self.data.append(DiscoverCellModel(title: "dubstep", image:#imageLiteral(resourceName: "dubstep.jpg")))
        self.data.append(DiscoverCellModel(title: "house", image: #imageLiteral(resourceName: "house.jpg")))

        






        
        
        
        
        
        
        
        self.tabBarController?.tabBar.items?[0].image =  #imageLiteral(resourceName: "Home").withRenderingMode(.alwaysOriginal)
        
        self.tabBarController?.tabBar.items?[1].image = #imageLiteral(resourceName: "Disc").withRenderingMode(.alwaysOriginal)
        
        
        self.tabBarController?.tabBar.items?[2].image = #imageLiteral(resourceName: "Search").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[3].image = #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal)
        self.tabBarController?.tabBar.items?[4].image = #imageLiteral(resourceName: "Profile").withRenderingMode(.alwaysOriginal)
        self.tblMain.delegate = self
        self.tblMain.dataSource = self
        self.tblMain.rowHeight = self.view.frame.height/4;
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        //removes small white line separating
        
        self.tblMain.separatorStyle=UITableViewCellSeparatorStyle.none;
        
        //here we need to link to backend to load in the data
        //simple for loop will work
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            //no looping
            return self.data.count
            
            //looping: return self.models.count*95 or whatever
        }
        return 0
    }
    func modelAtIndexPath(_ indexPath: IndexPath) -> DiscoverCellModel {
        return self.data[(indexPath as NSIndexPath).row % self.data.count]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! DiscoverImageCell
        cell.model = self.modelAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        //segue when user clicks category
        lastClicked = indexPath.row;
        
        self.performSegue(withIdentifier: "DiscoverBrowseSegue", sender: self)
        
    }
    //passing data during segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "DiscoverBrowseSegue") {
            
            //PASS DATA NEEDED TO BROWSE STUFF HERE
            
            let svc = segue.destination as! DiscoverBrowseViewController
            
            //passing in name value
            
            svc.name = data[lastClicked].title
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.tblMain) {
            for indexPath in self.tblMain.indexPathsForVisibleRows! {
                self.setCellImageOffset(self.tblMain.cellForRow(at: indexPath) as! DiscoverImageCell, indexPath: indexPath)
            }
        }
    }
    
    
    
    func setCellImageOffset(_ cell: DiscoverImageCell, indexPath: IndexPath) {
        let cellFrame = self.tblMain.rectForRow(at: indexPath)
        let cellFrameInTable = self.tblMain.convert(cellFrame, to:self.tblMain.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tblMain.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackgroundOffset(cellOffsetFactor)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let imageCell = cell as! DiscoverImageCell
        self.setCellImageOffset(imageCell, indexPath: indexPath)
    }
}

