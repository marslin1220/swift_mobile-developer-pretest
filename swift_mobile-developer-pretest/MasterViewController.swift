//
//  MasterViewController.swift
//  swift_mobile-developer-pretest
//
//  Created by Lin Cheng Lung on 2018/5/1.
//  Copyright © 2018 Lin Cheng Lung. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController?
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = splitViewController {
            let controllers = split.viewControllers
            guard let navigationController = controllers.last as? UINavigationController else {
                return
            }
            detailViewController = navigationController.topViewController as? DetailViewController
        }

        getDramaData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let object = objects[indexPath.row] as? NSDate else {
                    return
                }
                guard let navigationController = segue.destination as? UINavigationController else {
                    return
                }
                guard let controller = navigationController.topViewController as? DetailViewController else {
                    return
                }
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard let object = objects[indexPath.row] as? NSDate else {
            return cell
        }
        cell.textLabel!.text = object.description
        return cell
    }

    // MARK: - Private Method
    func getDramaData() {
        if let urlComponents = URLComponents(string: "http://www.mocky.io/v2/5a97c59c30000047005c1ed2") {

            guard let url = urlComponents.url else { return }

            let defaultSession = URLSession(configuration: .default)
            let dataTask = defaultSession.dataTask(with: url) { (data, urlResponse, error) in
                if let error = error {
                    print("Get an error: \(error)")
                } else if let jsonData = data, let response = urlResponse {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                    if let jsonString = String(bytes: jsonData, encoding: .utf8) {
                        print("Get data: \(jsonString), response: \(response)")
                    }

                    if let dramaData = try? jsonDecoder.decode(DramaData.self, from: jsonData) {
                        print("Get drama data: \(dramaData)")
                    }
                }
            }

            dataTask.resume()
        }
    }

}

struct DramaData: Codable {
    var data: [Drama]
}

struct Drama: Codable {
    var dramaId: Int
    var name: String
    var totalViews: Int
    var createdAt: Date
    var thumb: String
    var rating: Float

    enum CodingKeys: String, CodingKey {
        case dramaId = "drama_id"
        case name
        case totalViews = "total_views"
        case createdAt = "created_at"
        case thumb
        case rating
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
