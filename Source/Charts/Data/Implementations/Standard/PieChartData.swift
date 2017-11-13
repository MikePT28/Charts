//
//  PieData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

open class PieChartData: ChartData
{
    public override init()
    {
        super.init()
    }
    
    public override init(setsOfData: [IChartDataSet]?)
    {
        super.init(setsOfData: setsOfData)
    }

    @objc var dataSet: IPieChartDataSet?
    {
        get
        {
            return setsOfData.count > 0 ? setsOfData[0] as? IPieChartDataSet : nil
        }
        set
        {
            if newValue != nil
            {
                setsOfData = [newValue!]
            }
            else
            {
                setsOfData = []
            }
        }
    }
    
    open override func getDataSetByIndex(_ index: Int) -> IChartDataSet?
    {
        if index != 0
        {
            return nil
        }
        return super.getDataSetByIndex(index)
    }
    
    open override func getDataSetByLabel(_ label: String, ignorecase: Bool) -> IChartDataSet?
    {
        if setsOfData.count == 0 || setsOfData[0].label == nil
        {
            return nil
        }
        
        if ignorecase
        {
            if (label.caseInsensitiveCompare(setsOfData[0].label!) == ComparisonResult.orderedSame)
            {
                return setsOfData[0]
            }
        }
        else
        {
            if label == setsOfData[0].label
            {
                return setsOfData[0]
            }
        }
        return nil
    }
    
    open override func entryForHighlight(_ highlight: Highlight) -> ChartDataEntry?
    {
        return dataSet?.entryForIndex(Int(highlight.x))
    }
    
    open override func add(setOfData d: IChartDataSet!)
    {   
        super.add(setOfData: d)
    }
    
    /// Removes the DataSet at the given index in the DataSet array from the data object.
    /// Also recalculates all minimum and maximum values.
    ///
    /// - returns: `true` if a DataSet was removed, `false` ifno DataSet could be removed.
    open override func removeDataSetByIndex(_ index: Int) -> Bool
    {
        if index >= _setsOfData.count || index < 0
        {
            return false
        }
        
        return false
    }
    
    /// - returns: The total y-value sum across all DataSet objects the this object represents.
    @objc open var yValueSum: Double
    {
        guard let dataSet = dataSet else { return 0.0 }
        
        var yValueSum: Double = 0.0
        
        for i in 0..<dataSet.countOfEntries
        {
            yValueSum += dataSet.entryForIndex(i)?.y ?? 0.0
        }
        
        return yValueSum
    }
}
