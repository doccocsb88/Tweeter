//
//  MessageUtils.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
let maxCharactor = 50
enum MessageError: Error {
    case invalidLength
}
public func splitMessage(message:String) throws -> [String]{
    
    let estimateChild = assumpChild(message:message, maxLengh: maxCharactor)
    let stringArray = message.components(separatedBy: .whitespaces).filter {$0.count > 0 }
//    let stringLenArray = stringArray.filter {$0.count > 50}
//    if stringLenArray.count > 0{
//        throw MessageError.invalidLength
//        
//    }
    do{
        let splitedArray = try splitStringArray(stringArray: stringArray, childCount: estimateChild)
        var splitedMessage:[String] = [String]()
        var index = 1;
        let totalSubMessage = splitedArray.count
        for sub in splitedArray{
            
            let subMessage = "\(index)/\(totalSubMessage) \(sub)"
            splitedMessage.append(subMessage)
            index += 1
        }
        return splitedMessage
    }catch{
        throw MessageError.invalidLength

    }
  
}
public func splitStringArray(stringArray: [String], childCount: Int) throws -> [String]{
    var splitedArray = [String]();
    
    var estimateChild = childCount

    var curpage = 1;
    let averageWord = stringArray.count / estimateChild;
    var startIndex = 0;
//    var count = 0;
    var countMaxLenSubMessage = 0;
    while startIndex < stringArray.count{
        let prefix = "\(curpage)/\(estimateChild)"
        let prefixLen = prefix.count + 1
        //print("prefix  : \(prefix.count)")
        var nextIndex = startIndex + averageWord
        nextIndex = nextIndex <= stringArray.count ? nextIndex : stringArray.count
        var subArray = Array(stringArray[startIndex ..< nextIndex])
        //        subArray.insert(prefix, at: 0)
        //        var submessage = subArray.joined(separator: " ")
        var deltaIndex = averageWord
        var subMessageLen  = countLen(array: subArray)
//        count += 1
        if subMessageLen + prefixLen  < maxCharactor{
            for i in nextIndex ..< stringArray.count{
                //                    print("\(submessage.count) + \(stringArray[i].count) + \(prefix.count)")
                let nextWord = stringArray[i]
                subMessageLen = subMessageLen + (nextWord.count + 1)
                
//                count += 1
                if subMessageLen  + prefixLen >  maxCharactor{
                    break
                }else{
                    subArray.append(nextWord)
                    //                    submessage = subArray.joined(separator: " ")
                    deltaIndex += 1
                }
            }
        }else if (subMessageLen + prefixLen > maxCharactor ){
            var i =  nextIndex
            while i >= startIndex{
                if let lastWord = subArray.last{
                    subMessageLen -= (lastWord.count + 1)
                    if (lastWord.count > maxCharactor){
                        return []
                    }
                }
                subArray.removeLast()
                //                submessage = subArray.joined(separator: " ")
                i -= 1
                deltaIndex -= 1
//                count += 1
                if subMessageLen + prefixLen <= maxCharactor{
                    break
                }
                
            }
            
        }
        if subArray.count == 0{
            throw MessageError.invalidLength
        }
        let submessage = subArray.joined(separator: " ")

        //print("\(curpage)/\(estimateChild) ::::: \(submessage.count) : \(subArray.count) \(submessage)")
        splitedArray.append(submessage)
        curpage += 1
        startIndex += deltaIndex
        if submessage.count + prefixLen == maxCharactor{
            countMaxLenSubMessage += 1
        }
        if splitedArray.count == 1000 {
            //re-estimate total sub message after first 10000 submessage
            let estimateSubString = startIndex /  averageWord
            let deltaChild = splitedArray.count - estimateSubString
            if deltaChild > 0{
                estimateChild += deltaChild * ( stringArray.count / startIndex + 1)
            }
         
            print("nhuc dau")
        }
    }
//    print("count : \(count)")
    let estimatePrefix = "\(estimateChild)"
    let actualPrefix  = "\(splitedArray.count)"
    if actualPrefix.count > estimatePrefix.count {
        //
        //        let deltaPrefixLen = actualPrefix.count - assumpPrefix.count
        
        if countMaxLenSubMessage == 0{
            //make curtain when prefix length changed, it does not affect our result
            return splitedArray
            
        }else{
            print("de quy \(estimatePrefix) \(splitedArray.count + 1)")
            return try splitStringArray(stringArray:stringArray , childCount: splitedArray.count)
        }
    }else if actualPrefix.count < estimatePrefix.count{
        return try splitStringArray(stringArray:stringArray , childCount: splitedArray.count)

    }
    //307 -- 385
    return splitedArray
    
}

func isCorrectSplited(messages:[String], prefixLen:Int) -> Bool{
    
    let values = messages.map{$0.count <= maxCharactor - prefixLen}
    for i in 0 ..< values.count{
        if values[i] == false{
            return false
        }
    }
    return true
}
func getExtraString(count:Int) -> Int{
    var extrar = 0;
    for i in 1 ... count{
        let prefix  = "\(i)/\(count)"
        extrar += (prefix.count + 1)
    }
    return extrar
}
public func assumpChild(message:String, maxLengh: Int) -> Int{
    let count = message.count / maxLengh + 1;
    let stringLen = (message.count + getExtraString(count: count))
    var child  = stringLen / maxLengh
    if stringLen  % maxLengh != 0{
        child += 1
    }
    return child
}

public func countLen(array:[String]) -> Int{
    let countWhiteSpace = array.count - 1
    var count = countWhiteSpace;
    for i in 0 ..< array.count{
        count += array[i].count
    }
    return count
}

