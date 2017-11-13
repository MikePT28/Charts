//
//  ChartData.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

open class ChartData: NSObject
{
    @objc internal var _yMax: Double = -Double.greatestFiniteMagnitude
    @objc internal var _yMin: Double = Double.greatestFiniteMagnitude
    @objc internal var _xMax: Double = -Double.greatestFiniteMagnitude
    @objc internal var _xMin: Double = Double.greatestFiniteMagnitude
    @objc internal var _leftAxisMax: Double = -Double.greatestFiniteMagnitude
    @objc internal var _leftAxisMin: Double = Double.greatestFiniteMagnitude
    @objc internal var _rightAxisMax: Double = -Double.greatestFiniteMagnitude
    @objc internal var _rightAxisMin: Double = Double.greatestFiniteMagnitude
    
    @objc internal var _setsOfData = [IChartDataSet]()
    
    public override init()
    {
        super.init()
        
        _setsOfData = [IChartDataSet]()
    }
    
    @objc public init(setsOfData: [IChartDataSet]?)
    {
        super.init()
        
        _setsOfData = setsOfData ?? [IChartDataSet]()
        
        self.initialize(setsOfData: _setsOfData)
    }
    
    @objc public convenience init(setOfData: IChartDataSet?)
    {
        self.init(setsOfData: setOfData === nil ? nil : [setOfData!])
    }
    
    @objc internal func initialize(setsOfData: [IChartDataSet])
    {
        notifyDataChanged()
    }
    
    /// Call this method to let the ChartData know that the underlying data has changed.
    /// Calling this performs all necessary recalculations needed when the contained data has changed.
    @objc open func notifyDataChanged()
    {
        calcMinMax()
    }
    
    @objc open func calcMinMaxY(fromX: Double, toX: Double)
    {
        for set in _setsOfData
        {
            set.calcMinMaxY(fromX: fromX, toX: toX)
        }
        
        // apply the new data
        calcMinMax()
    }
    
    /// calc minimum and maximum y value over all datasets
    @objc open func calcMinMax()
    {
        _yMax = -Double.greatestFiniteMagnitude
        _yMin = Double.greatestFiniteMagnitude
        _xMax = -Double.greatestFiniteMagnitude
        _xMin = Double.greatestFiniteMagnitude
        
        for set in _setsOfData
        {
            calcMinMax(setOfData: set)
        }
        
        _leftAxisMax = -Double.greatestFiniteMagnitude
        _leftAxisMin = Double.greatestFiniteMagnitude
        _rightAxisMax = -Double.greatestFiniteMagnitude
        _rightAxisMin = Double.greatestFiniteMagnitude
        
        // left axis
        let firstLeft = getFirstLeft(setsOfData: setsOfData)
        
        if firstLeft !== nil
        {
            _leftAxisMax = firstLeft!.yMax
            _leftAxisMin = firstLeft!.yMin
            
            for setOfData in _setsOfData
            {
                if setOfData.axisDependency == .left
                {
                    if setOfData.yMin < _leftAxisMin
                    {
                        _leftAxisMin = setOfData.yMin
                    }
                    
                    if setOfData.yMax > _leftAxisMax
                    {
                        _leftAxisMax = setOfData.yMax
                    }
                }
            }
        }
        
        // right axis
        let firstRight = getFirstRight(setsOfData: setsOfData)
        
        if firstRight !== nil
        {
            _rightAxisMax = firstRight!.yMax
            _rightAxisMin = firstRight!.yMin
            
            for setOfData in _setsOfData
            {
                if setOfData.axisDependency == .right
                {
                    if setOfData.yMin < _rightAxisMin
                    {
                        _rightAxisMin = setOfData.yMin
                    }
                    
                    if setOfData.yMax > _rightAxisMax
                    {
                        _rightAxisMax = setOfData.yMax
                    }
                }
            }
        }
    }
    
    /// Adjusts the current minimum and maximum values based on the provided Entry object.
    @objc open func calcMinMax(entry e: ChartDataEntry, axis: YAxis.AxisDependency)
    {
        if _yMax < e.y
        {
            _yMax = e.y
        }
        
        if _yMin > e.y
        {
            _yMin = e.y
        }
        
        if _xMax < e.x
        {
            _xMax = e.x
        }
        
        if _xMin > e.x
        {
            _xMin = e.x
        }
        
        if axis == .left
        {
            if _leftAxisMax < e.y
            {
                _leftAxisMax = e.y
            }
            
            if _leftAxisMin > e.y
            {
                _leftAxisMin = e.y
            }
        }
        else
        {
            if _rightAxisMax < e.y
            {
                _rightAxisMax = e.y
            }
            
            if _rightAxisMin > e.y
            {
                _rightAxisMin = e.y
            }
        }
    }
    
    /// Adjusts the minimum and maximum values based on the given DataSet.
    @objc open func calcMinMax(setOfData d: IChartDataSet)
    {
        if _yMax < d.yMax
        {
            _yMax = d.yMax
        }
        
        if _yMin > d.yMin
        {
            _yMin = d.yMin
        }
        
        if _xMax < d.xMax
        {
            _xMax = d.xMax
        }
        
        if _xMin > d.xMin
        {
            _xMin = d.xMin
        }
        
        if d.axisDependency == .left
        {
            if _leftAxisMax < d.yMax
            {
                _leftAxisMax = d.yMax
            }
            
            if _leftAxisMin > d.yMin
            {
                _leftAxisMin = d.yMin
            }
        }
        else
        {
            if _rightAxisMax < d.yMax
            {
                _rightAxisMax = d.yMax
            }
            
            if _rightAxisMin > d.yMin
            {
                _rightAxisMin = d.yMin
            }
        }
    }
    
    /// - returns: The number of LineDataSets this object contains
    @objc open var dataSetCount: Int
    {
        return _setsOfData.count
    }
    
    /// - returns: The smallest y-value the data object contains.
    @objc open var yMin: Double
    {
        return _yMin
    }
    
    @nonobjc
    open func getYMin() -> Double
    {
        return _yMin
    }
    
    @objc open func getYMin(axis: YAxis.AxisDependency) -> Double
    {
        if axis == .left
        {
            if _leftAxisMin == Double.greatestFiniteMagnitude
            {
                return _rightAxisMin
            }
            else
            {
                return _leftAxisMin
            }
        }
        else
        {
            if _rightAxisMin == Double.greatestFiniteMagnitude
            {
                return _leftAxisMin
            }
            else
            {
                return _rightAxisMin
            }
        }
    }
    
    /// - returns: The greatest y-value the data object contains.
    @objc open var yMax: Double
    {
        return _yMax
    }
    
    @nonobjc
    open func getYMax() -> Double
    {
        return _yMax
    }
    
    @objc open func getYMax(axis: YAxis.AxisDependency) -> Double
    {
        if axis == .left
        {
            if _leftAxisMax == -Double.greatestFiniteMagnitude
            {
                return _rightAxisMax
            }
            else
            {
                return _leftAxisMax
            }
        }
        else
        {
            if _rightAxisMax == -Double.greatestFiniteMagnitude
            {
                return _leftAxisMax
            }
            else
            {
                return _rightAxisMax
            }
        }
    }
    
    /// - returns: The minimum x-value the data object contains.
    @objc open var xMin: Double
    {
        return _xMin
    }
    /// - returns: The maximum x-value the data object contains.
    @objc open var xMax: Double
    {
        return _xMax
    }
    
    /// - returns: All DataSet objects this ChartData object holds.
    @objc open var setsOfData: [IChartDataSet]
    {
        get
        {
            return _setsOfData
        }
        set
        {
            _setsOfData = newValue
            notifyDataChanged()
        }
    }
    
    /// Retrieve the index of a ChartDataSet with a specific label from the ChartData. Search can be case sensitive or not.
    /// 
    /// **IMPORTANT: This method does calculations at runtime, do not over-use in performance critical situations.**
    ///
    /// - parameter dataSets: the DataSet array to search
    /// - parameter type:
    /// - parameter ignorecase: if true, the search is not case-sensitive
    /// - returns: The index of the DataSet Object with the given label. Sensitive or not.
    @objc internal func getDataSetIndexByLabel(_ label: String, ignorecase: Bool) -> Int
    {
        if ignorecase
        {
            for i in 0 ..< setsOfData.count
            {
                if setsOfData[i].label == nil
                {
                    continue
                }
                if (label.caseInsensitiveCompare(setsOfData[i].label!) == ComparisonResult.orderedSame)
                {
                    return i
                }
            }
        }
        else
        {
            for i in 0 ..< setsOfData.count
            {
                if label == setsOfData[i].label
                {
                    return i
                }
            }
        }
        
        return -1
    }
    
    /// - returns: The labels of all DataSets as a string array.
    @objc internal func dataSetLabels() -> [String]
    {
        var types = [String]()
        
        for i in 0 ..< _setsOfData.count
        {
            if setsOfData[i].label == nil
            {
                continue
            }
            
            types[i] = _setsOfData[i].label!
        }
        
        return types
    }
    
    /// Get the Entry for a corresponding highlight object
    ///
    /// - parameter highlight:
    /// - returns: The entry that is highlighted
    @objc open func entryForHighlight(_ highlight: Highlight) -> ChartDataEntry?
    {
        if highlight.indexOfDataSet >= setsOfData.count
        {
            return nil
        }
        else
        {
            return setsOfData[highlight.indexOfDataSet].entryForXValue(highlight.x, closestToY: highlight.y)
        }
    }
    
    /// **IMPORTANT: This method does calculations at runtime. Use with care in performance critical situations.**
    ///
    /// - parameter label:
    /// - parameter ignorecase:
    /// - returns: The DataSet Object with the given label. Sensitive or not.
    @objc open func getDataSetByLabel(_ label: String, ignorecase: Bool) -> IChartDataSet?
    {
        let index = getDataSetIndexByLabel(label, ignorecase: ignorecase)
        
        if index < 0 || index >= _setsOfData.count
        {
            return nil
        }
        else
        {
            return _setsOfData[index]
        }
    }
    
    @objc open func getDataSetByIndex(_ index: Int) -> IChartDataSet!
    {
        if index < 0 || index >= _setsOfData.count
        {
            return nil
        }
        
        return _setsOfData[index]
    }
    
    @objc open func add(setOfData: IChartDataSet!)
    {
        calcMinMax(setOfData: setOfData)
        
        _setsOfData.append(setOfData)
    }
    
    /// Removes the given DataSet from this data object.
    /// Also recalculates all minimum and maximum values.
    ///
    /// - returns: `true` if a DataSet was removed, `false` ifno DataSet could be removed.
    @objc @discardableResult open func remove( setOfData: IChartDataSet!) -> Bool
    {
        if setOfData === nil
        {
            return false
        }
        
        for i in 0 ..< _setsOfData.count
        {
            if _setsOfData[i] === setOfData
            {
                return removeDataSetByIndex(i)
            }
        }
        
        return false
    }
    
    /// Removes the DataSet at the given index in the DataSet array from the data object. 
    /// Also recalculates all minimum and maximum values. 
    ///
    /// - returns: `true` if a DataSet was removed, `false` ifno DataSet could be removed.
    @objc @discardableResult open func removeDataSetByIndex(_ index: Int) -> Bool
    {
        if index >= _setsOfData.count || index < 0
        {
            return false
        }
        
        _setsOfData.remove(at: index)
        
        calcMinMax()
        
        return true
    }
    
    /// Adds an Entry to the DataSet at the specified index. Entries are added to the end of the list.
    @objc open func addEntry(_ e: ChartDataEntry, dataSetIndex: Int)
    {
        if _setsOfData.count > dataSetIndex && dataSetIndex >= 0
        {
            let set = _setsOfData[dataSetIndex]
            
            if !set.addEntry(e) { return }
            
            calcMinMax(entry: e, axis: set.axisDependency)
        }
        else
        {
            print("ChartData.addEntry() - Cannot add Entry because dataSetIndex too high or too low.", terminator: "\n")
        }
    }
    
    /// Removes the given Entry object from the DataSet at the specified index.
    @objc @discardableResult open func removeEntry(_ entry: ChartDataEntry, dataSetIndex: Int) -> Bool
    {
        // entry outofbounds
        if dataSetIndex >= _setsOfData.count
        {
            return false
        }
        
        // remove the entry from the dataset
        let removed = _setsOfData[dataSetIndex].removeEntry(entry)
        
        if removed
        {
            calcMinMax()
        }
        
        return removed
    }
    
    /// Removes the Entry object closest to the given xIndex from the ChartDataSet at the
    /// specified index. 
    /// - returns: `true` if an entry was removed, `false` ifno Entry was found that meets the specified requirements.
    @objc @discardableResult open func removeEntry(xValue: Double, dataSetIndex: Int) -> Bool
    {
        if dataSetIndex >= _setsOfData.count
        {
            return false
        }
        
        if let entry = _setsOfData[dataSetIndex].entryForXValue(xValue, closestToY: Double.nan)
        {
            return removeEntry(entry, dataSetIndex: dataSetIndex)
        }
        
        return false
    }
    
    /// - returns: The DataSet that contains the provided Entry, or null, if no DataSet contains this entry.
    @objc open func getDataSetForEntry(_ e: ChartDataEntry!) -> IChartDataSet?
    {
        if e == nil
        {
            return nil
        }
        
        for i in 0 ..< _setsOfData.count
        {
            let set = _setsOfData[i]
            
            if e === set.entryForXValue(e.x, closestToY: e.y)
            {
                return set
            }
        }
        
        return nil
    }

    /// - returns: The index of the provided DataSet in the DataSet array of this data object, or -1 if it does not exist.
    @objc open func indexOfDataSet(_ dataSet: IChartDataSet) -> Int
    {
        for i in 0 ..< _setsOfData.count
        {
            if _setsOfData[i] === dataSet
            {
                return i
            }
        }
        
        return -1
    }
    
    /// - returns: The first DataSet from the datasets-array that has it's dependency on the left axis. Returns null if no DataSet with left dependency could be found.
    @objc open func getFirstLeft(setsOfData: [IChartDataSet]) -> IChartDataSet?
    {
        for dataSet in setsOfData
        {
            if dataSet.axisDependency == .left
            {
                return dataSet
            }
        }
        
        return nil
    }
    
    /// - returns: The first DataSet from the datasets-array that has it's dependency on the right axis. Returns null if no DataSet with right dependency could be found.
    @objc open func getFirstRight(setsOfData: [IChartDataSet]) -> IChartDataSet?
    {
        for dataSet in _setsOfData
        {
            if dataSet.axisDependency == .right
            {
                return dataSet
            }
        }
        
        return nil
    }
    
    /// - returns: All colors used across all DataSet objects this object represents.
    @objc open func getColors() -> [NSUIColor]?
    {
        var clrcnt = 0
        
        for i in 0 ..< _setsOfData.count
        {
            clrcnt += _setsOfData[i].colors.count
        }
        
        var colors = [NSUIColor]()
        
        for i in 0 ..< _setsOfData.count
        {
            let clrs = _setsOfData[i].colors
            
            for clr in clrs
            {
                colors.append(clr)
            }
        }
        
        return colors
    }
    
    /// Sets a custom IValueFormatter for all DataSets this data object contains.
    @objc open func formatterOfValue(formatter: IValueFormatter?)
    {
        guard let formatter = formatter
            else { return }
        
        for set in setsOfData
        {
            set.valueFormatter = formatter
        }
    }
    
    /// Sets the color of the value-text (color in which the value-labels are drawn) for all DataSets this data object contains.
    @objc open func setValueTextColor(_ color: NSUIColor!)
    {
        for set in setsOfData
        {
            set.valueTextColor = color ?? set.valueTextColor
        }
    }
    
    /// Sets the font for all value-labels for all DataSets this data object contains.
    @objc open func fontOfValue(font: NSUIFont!)
    {
        for set in setsOfData
        {
            set.valueFont = font ?? set.valueFont
        }
    }
    
    /// Enables / disables drawing values (value-text) for all DataSets this data object contains.
    @objc open func setDrawValues(_ enabled: Bool)
    {
        for set in setsOfData
        {
            set.drawValuesEnabled = enabled
        }
    }
    
    /// Enables / disables highlighting values for all DataSets this data object contains.
    /// If set to true, this means that values can be highlighted programmatically or by touch gesture.
    @objc open var highlightEnabled: Bool
    {
        get
        {
            for set in setsOfData
            {
                if !set.highlightEnabled
                {
                    return false
                }
            }
            
            return true
        }
        set
        {
            for set in setsOfData
            {
                set.highlightEnabled = newValue
            }
        }
    }
    
    /// if true, value highlightning is enabled
    @objc open var isHighlightEnabled: Bool { return highlightEnabled }
    
    /// Clears this data object from all DataSets and removes all Entries.
    /// Don't forget to invalidate the chart after this.
    @objc open func clearValues()
    {
        setsOfData.removeAll(keepingCapacity: false)
        notifyDataChanged()
    }
    
    /// Checks if this data object contains the specified DataSet. 
    /// - returns: `true` if so, `false` ifnot.
    @objc open func contains(dataSet: IChartDataSet) -> Bool
    {
        for set in setsOfData
        {
            if set === dataSet
            {
                return true
            }
        }
        
        return false
    }
    
    /// - returns: The total entry count across all DataSet objects this data object contains.
    @objc open var countOfEntries: Int
    {
        var count = 0
        
        for set in _setsOfData
        {
            count += set.countOfEntries
        }
        
        return count
    }

    /// - returns: The DataSet object with the maximum number of entries or null if there are no DataSets.
    @objc open var maxEntryCountSet: IChartDataSet?
    {
        if _setsOfData.count == 0
        {
            return nil
        }
        
        var max = _setsOfData[0]
        
        for set in _setsOfData
        {
            if set.countOfEntries > max.countOfEntries
            {
                max = set
            }
        }
        
        return max
    }
}
