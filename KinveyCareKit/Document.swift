//
//  Document.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-11.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import ObjectMapper

extension OCKDocument {
    
    public convenience init(_ document: Document) {
        self.init(title: document.title, elements: document.elements)
        self.pageHeader = document.pageHeader
    }
    
}

extension OCKDocumentElementSubtitle: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return OCKDocumentElementSubtitle()
    }
    
    public func mapping(map: Map) {
        subtitle <- map["subtitle"]
    }
    
}

extension OCKDocumentElementParagraph: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return OCKDocumentElementParagraph()
    }
    
    public func mapping(map: Map) {
        content <- map["content"]
    }
    
}

extension OCKDocumentElementImage: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return OCKDocumentElementImage()
    }
    
    public func mapping(map: Map) {
        image <- (map["image"], TransformOf<UIImage, String>(fromJSON: { (base64) -> UIImage? in
            if let base64 = base64,
                let data = Data(base64Encoded: base64),
                let uiImage = UIImage(data: data)
            {
                return uiImage
            }
            
            return nil
        }, toJSON: { (image) -> String? in
            if let image = image,
                let data = UIImagePNGRepresentation(image)
            {
                return data.base64EncodedString()
            }
            
            return nil
        }))
    }
    
}

extension OCKDocumentElementTable: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return OCKDocumentElementTable()
    }
    
    public func mapping(map: Map) {
        headers <- map["headers"]
        rows <- map["rows"]
    }
    
}

extension OCKDocumentElementChart: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        return OCKDocumentElementChart()
    }
    
    public func mapping(map: Map) {
        chart <- map["chart"]
    }
    
}

extension OCKChart: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        guard let dataSeries: [[String : Any]] = map["dataSeries"].value() else {
            return nil
        }
        
        let title: String? = map["title"].value()
        let text: String? = map["text"].value()
        let tintColor: Any? = map["tintColor"].value()
        let axisTitles: [String]? = map["axisTitles"].value()
        let axisSubtitles: [String]? = map["axisSubtitles"].value()
        let minimumScaleRangeValue: NSNumber? = map["minimumScaleRangeValue"].value()
        let maximumScaleRangeValue: NSNumber? = map["maximumScaleRangeValue"].value()
        
        return OCKBarChart(
            title: title,
            text: text,
            tintColor: UIColorTransform().transformFromJSON(tintColor),
            axisTitles: axisTitles,
            axisSubtitles: axisSubtitles,
            dataSeries: dataSeries.flatMap({ OCKBarSeries(JSON: $0) }),
            minimumScaleRangeValue: minimumScaleRangeValue,
            maximumScaleRangeValue: maximumScaleRangeValue
        )
    }

    public func mapping(map: Map) {
        title <- map["title"]
        text <- map["text"]
        tintColor <- map["tintColor"]
        if let barChart = self as? OCKBarChart {
            barChart.axisTitles >>> map["axisTitles"]
            barChart.axisSubtitles >>> map["axisSubtitles"]
            barChart.dataSeries >>> map["dataSeries"]
        }
    }
    
}

extension OCKBarSeries: StaticMappable {
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        guard
            let title: String = map["title"].value(),
            let values: [NSNumber] = map["values"].value(),
            let valueLabels: [String] = map["valueLabels"].value(),
            let tintColor: Any? = map["tintColor"].value()
        else {
            return nil
        }
        
        return OCKBarSeries(
            title: title,
            values: values,
            valueLabels: valueLabels,
            tintColor: UIColorTransform().transformFromJSON(tintColor)
        )
    }
    
    public func mapping(map: Map) {
        title >>> map["title"]
        values >>> map["values"]
        valueLabels >>> map["valueLabels"]
        tintColor >>> (map["tintColor"], UIColorTransform())
    }
    
}

public class Document: Entity {
    
    public var title: String?
    public var pageHeader: String?
    public var elements: [OCKDocumentElement]?
    public var htmlContent: String?
    
    override public class func collectionName() -> String {
        return "Document"
    }
    
    public convenience init(_ document: OCKDocument) {
        self.init()
        
        title = document.title
        pageHeader = document.pageHeader
        elements = document.elements
        htmlContent = document.htmlContent
    }
    
    public override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        title <- ("title", map["title"])
        pageHeader <- ("pageHeader", map["pageHeader"])
        elements <- ("elements", map["elements"], TransformOf<[OCKDocumentElement], [[String : Any]]>(fromJSON: { (jsonArray) -> [OCKDocumentElement]? in
            guard let jsonArray = jsonArray else {
                return nil
            }
            
            return jsonArray.flatMap { (json) -> OCKDocumentElement? in
                if let subtitle = json["subtitle"] as? String {
                    return OCKDocumentElementSubtitle(subtitle: subtitle)
                } else if let content = json["content"] as? String {
                    return OCKDocumentElementParagraph(content: content)
                } else if let image = json["image"] as? String,
                    let data = Data(base64Encoded: image),
                    let uiImage = UIImage(data: data)
                {
                    return OCKDocumentElementImage(image: uiImage)
                } else if let headers = json["headers"] as? [String],
                    let rows = json["rows"] as? [[String]]
                {
                    return OCKDocumentElementTable(headers: headers, rows: rows)
                } else if let jsonChart = json["chart"] as? [String : Any],
                    let chart = OCKChart(JSON: jsonChart)
                {
                    return OCKDocumentElementChart(chart: chart)
                }
                
                return nil
            }
        }, toJSON: { (elements) -> [[String : Any]]? in
            guard let elements = elements else {
                return nil
            }
            
            return elements.flatMap { (element) -> [String : Any]? in
                switch element {
                case let mappable as BaseMappable:
                    return mappable.toJSON()
                default:
                    return nil
                }
            }
        }))
        htmlContent <- ("htmlContent", map["htmlContent"])
    }
    
}
