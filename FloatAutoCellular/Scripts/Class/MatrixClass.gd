extends Node

# In order to reduce the performance loss caused by multiple function calls,
# I concentrated the functionality into a few functions, I admit it looks ugly...

class_name FloatAutoCellularMatrix

var MatrixWidth: int;
var MatrixLength: int;

var CellStateMatrix: Array[Array];

var CalcFloatMatrix: Array[Array];
var AnimFloatMatrix: Array[Array];

var IsKeepMeansKeepCellHp:bool = true;

####################################################################################################
#CalcCellState's rule
var NeighboorLessLiveMoreDie:float = 3.5;
var NeighboorLessKeepMoreLive:float = 2.5;
var NeighboorLessDieMoreKeep:float = 1.5;

func InitNeighboorLessLiveMoreDieValue(value: float) -> bool:
	if value > 8:
		value = 8;
	elif value < 0:
		value = 0;
	NeighboorLessLiveMoreDie = value;
	var hasChangeOtherValue = false;
	if NeighboorLessKeepMoreLive > value:
		InitNeighboorLessKeepMoreLiveValue(value);
		hasChangeOtherValue = true;
	return hasChangeOtherValue;
func InitNeighboorLessKeepMoreLiveValue(value: float) -> bool:
	if value > 8:
		value = 8;
	elif value < 0:
		value = 0;
	NeighboorLessKeepMoreLive = value;
	var hasChangeOtherValue = false;
	if NeighboorLessLiveMoreDie < value:
		InitNeighboorLessLiveMoreDieValue(value);
		hasChangeOtherValue = true;
	if NeighboorLessDieMoreKeep > value:
		InitNeighboorLessDieMoreKeepValue(value);
		hasChangeOtherValue = true;
	return hasChangeOtherValue;
func InitNeighboorLessDieMoreKeepValue(value: float) -> bool:
	if value > 8:
		value = 8;
	elif value < 0:
		value = 0;
	NeighboorLessDieMoreKeep = value;
	var hasChangeOtherValue = false;
	if NeighboorLessKeepMoreLive < value:
		InitNeighboorLessKeepMoreLiveValue(value);
		hasChangeOtherValue = true;
	return hasChangeOtherValue;
####################################################################################################

var rng:RandomNumberGenerator;

func SetKeepMean(isKeepMeansKeepCellHp: bool) -> void:
	IsKeepMeansKeepCellHp = isKeepMeansKeepCellHp;

func InitMatrix(matrixWidth: int, matrixLength: int, p:int = 15) -> void:
	rng = RandomNumberGenerator.new();
	MatrixWidth = matrixWidth + 2;
	MatrixLength = matrixLength + 2;
	for x in range(MatrixWidth):
		var newCalcFloatMatrix:Array[float] = [];
		var newAnimFloatMatrix:Array[float] = [];
		var newCellStateMatrix:Array[DataStruct.CellState] = [];
		CalcFloatMatrix.append(newCalcFloatMatrix);
		AnimFloatMatrix.append(newAnimFloatMatrix);
		CellStateMatrix.append(newCellStateMatrix);
		for y in range(MatrixLength):
			CalcFloatMatrix[x].append(0);
			AnimFloatMatrix[x].append(0);
			CellStateMatrix[x].append(DataStruct.CellState.DIE);
	RandomMatrix(p);
	
func RandomMatrix(p: int) -> void:
	var randomInt:int;
	for x in range(1, MatrixWidth - 1):
		for y in range(1, MatrixLength - 1):
			randomInt = rng.randi_range(0, 99);
			if randomInt < p:# true
				CalcFloatMatrix[x][y] = 1;
				AnimFloatMatrix[x][y] = 1;
				CellStateMatrix[x][y] = DataStruct.CellState.LIVE;
				pass
			else:# false
				CalcFloatMatrix[x][y] = 0;
				AnimFloatMatrix[x][y] = 0;
				CellStateMatrix[x][y] = DataStruct.CellState.DIE;
				pass

func CalcUpdate(x1:int, x2:int, y1:int, y2:int, delta: float) -> void:
	var currentHp: float;
	var currentCellState: DataStruct.CellState;
	var cellHpUpValue:float = delta * MatrixVariable.CellGrowSpeed;
	var cellHpDownValue:float = delta * MatrixVariable.CellDieSpeed;
	for x in range(x1, x2 + 1):
		for y in range(y1, y2 + 1):
			currentCellState = CellStateMatrix[x][y];
			if currentCellState == DataStruct.CellState.LIVING:
				currentHp = CalcFloatMatrix[x][y] + cellHpUpValue;
				if currentHp > 1:
					currentHp = 1;
				AnimFloatMatrix[x][y] = currentHp;
			elif currentCellState == DataStruct.CellState.DYING:
				currentHp = CalcFloatMatrix[x][y] - cellHpDownValue;
				if currentHp < 0:
					currentHp = 0;
				AnimFloatMatrix[x][y] = currentHp;

func CalcNextRound() -> void:
	CalibrateMatrix();
	var neighboorsHP:float;
	var currentCellState:DataStruct.CellState;
	for x in range(1, MatrixWidth - 1):
		for y in range(1, MatrixLength - 1):
			neighboorsHP = -CalcFloatMatrix[x][y];
			for i in range(-1, 2):
				for j in range(-1, 2):
					neighboorsHP += CalcFloatMatrix[x + i][y + j];
			#currentCellState = CalcCellState(neighboorsHP);
			if neighboorsHP > NeighboorLessLiveMoreDie:	
				currentCellState = DataStruct.CellState.DYING;
			elif neighboorsHP > NeighboorLessKeepMoreLive:
				currentCellState =  DataStruct.CellState.LIVING;
			elif neighboorsHP > NeighboorLessDieMoreKeep:
				currentCellState =  DataStruct.CellState.KEEP;
			else:
				currentCellState =  DataStruct.CellState.DYING;
		
			if currentCellState == DataStruct.CellState.KEEP and IsKeepMeansKeepCellHp == false:
				currentCellState = CellStateMatrix[x][y];
			CellStateMatrix[x][y] = currentCellState;
			if currentCellState == DataStruct.CellState.LIVING:
				if CalcFloatMatrix[x][y] == 1:
					CellStateMatrix[x][y] = DataStruct.CellState.LIVE;
			elif currentCellState == DataStruct.CellState.DYING:
				if CalcFloatMatrix[x][y] == 0:
					CellStateMatrix[x][y] = DataStruct.CellState.DIE;

func CalibrateMatrix() -> void:
	var cellHpUpValue:float = MatrixVariable.CellGrowSpeed * MatrixVariable.CalcIntervals;
	var cellHpDownValue:float = MatrixVariable.CellDieSpeed * MatrixVariable.CalcIntervals;
	var currentHp:float = 0;
	var currentCellState:DataStruct.CellState;
	var hasChangeHp:bool = false;
	for x in range(1, MatrixWidth):
		for y in range(1, MatrixLength):
			currentCellState = CellStateMatrix[x][y];
			currentHp = CalcFloatMatrix[x][y]
			hasChangeHp = false;
			if currentCellState == DataStruct.CellState.LIVING:
				hasChangeHp = true;
				currentHp += cellHpUpValue;
				if currentHp > 1:
					currentHp = 1;
					CellStateMatrix[x][y] = DataStruct.CellState.LIVE;
			elif currentCellState == DataStruct.CellState.DYING:
				hasChangeHp = true;
				currentHp -= cellHpDownValue;
				if currentHp < 0:
					currentHp = 0;
					CellStateMatrix[x][y] = DataStruct.CellState.DIE;
			
			if hasChangeHp:
				AnimFloatMatrix[x][y] = currentHp;
				CalcFloatMatrix[x][y] = currentHp;


func SetCellStateInMatrix(x: int, y: int, willLive: bool = true) -> bool:
	if x < 1 or y < 1 or x > MatrixWidth - 2 or y > MatrixLength - 2:
		return false;
	if willLive:
		CellStateMatrix[x][y] = DataStruct.CellState.LIVE;
		CalcFloatMatrix[x][y] = 1;
		AnimFloatMatrix[x][y] = 1;
	else:
		CellStateMatrix[x][y] = DataStruct.CellState.DIE;
		CalcFloatMatrix[x][y] = 0;
		AnimFloatMatrix[x][y] = 0;
	return true;

"""
class NeighboorsRule:
	var NeighboorAmountList:Array[float];
	var NeighboorStateList:Array[DataStruct.CellState];
	var RuleLength:int;
	var From0ToSmallestNeighboorAmountCellState:DataStruct.CellState;
	
	func InitRule() -> void:
		NeighboorAmountList = [];
		NeighboorStateList = [];
		RuleLength = 0;
		From0ToSmallestNeighboorAmountCellState = DataStruct.CellState.DIE;
	func AddRule(neighboorAmount: float, cellState:DataStruct.CellState):
		if neighboorAmount > 8 || neighboorAmount < 0:
			return;
		if RuleLength == 0:
			NeighboorAmountList.append(neighboorAmount);
			NeighboorStateList.append(cellState);
			RuleLength += 1;
			return;
		for i in range(RuleLength):
			if i+1 > RuleLength-1:
				InsertRule(i, neighboorAmount, cellState);
				return;
			elif neighboorAmount <= NeighboorAmountList[i] and neighboorAmount >= NeighboorAmountList[i+1]:
				InsertRule(i+1, neighboorAmount, cellState);
				return;
	func ChangeFrom0ToSmallestNeighboorAmountCellState(cellState: DataStruct.CellState):
		From0ToSmallestNeighboorAmountCellState = cellState;
	func InsertRule(insertPosition: int, neighboorsAmount: int, cellState: DataStruct.CellState):
		if NeighboorAmountList.insert(insertPosition, neighboorsAmount):
			NeighboorStateList.insert(insertPosition, cellState);
			RuleLength += 1;
			
	func CalcCellState(neighboorsHp:float) -> DataStruct.CellState:
		for i in range(RuleLength):
			if neighboorsHp > NeighboorAmountList[i]:
				return NeighboorStateList[i];
		return From0ToSmallestNeighboorAmountCellState;
"""
