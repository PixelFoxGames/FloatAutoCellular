extends Node
#GLOBAL

const MAX_MATRIX_WIDTH:int = 10000;
const MAX_MATRIX_LENGTH:int = 10000;

var CellGrowSpendTime:float = 1;
var CellDieSpendTime:float = 1;
var CalcIntervals:float = 1;

var CellGrowSpeed:float;
var CellDieSpeed:float;

var Matrix:FloatAutoCellularMatrix;
var MatrixWidth:int;
var MatrixLength:int;

var NeighboorLessLiveMoreDie:float = 3.5;
var NeighboorLessKeepMoreLive:float = 2.5;
var NeighboorLessDieMoreKeep:float = 1.5;

func InitDefaultRules() -> void:
	SetKeepMean(true);
	InitTimerValue(1, 1, 1)
	NeighboorLessLiveMoreDie = 3.5
	NeighboorLessKeepMoreLive = 2.5
	NeighboorLessDieMoreKeep = 1.5
####################################################################################################
#Rule
func SetKeepMean(isKeepMeansKeepCellHp:bool) -> void:
	Matrix.SetKeepMean(isKeepMeansKeepCellHp);
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
#Time
func InitTimerValue(growSpendTime:float, dieSpendTime:float, intervals:float) -> void:
	InitCellGrowValue(growSpendTime);
	InitCellDieValue(dieSpendTime);
	InitCalcIntervalsValue(intervals);
func InitCellGrowValue(growSpendTime:float):
	if growSpendTime < 0.05:
		growSpendTime = 0.05;
	CellGrowSpendTime = growSpendTime;
	CellGrowSpeed = 1 / growSpendTime;
func InitCellDieValue(dieSpendTime:float):
	if dieSpendTime < 0.05:
		dieSpendTime = 0.05;
	CellDieSpendTime = dieSpendTime;
	CellDieSpeed = 1 / dieSpendTime;
func InitCalcIntervalsValue(intervals:float):
	if intervals < 0.05:
		intervals = 0.05;
	CalcIntervals = intervals;
####################################################################################################
#Matrix
func InitMatrix(matrixWidth: int, matrixLength: int) -> void:
	Matrix = FloatAutoCellularMatrix.new();
	Matrix.InitMatrix(matrixWidth, matrixLength, 15);
	MatrixWidth = matrixWidth;
	MatrixLength = matrixLength;

func RandomMatrix(p:int = 15) -> void:
	Matrix.RandomMatrix(p);
	
func CalcUpdate(x1:int, x2:int, y1:int, y2:int, delta:float) -> void:
	Matrix.CalcUpdate(x1, x2, y1, y2, delta);

func CalcNextRound() -> void:
	Matrix.CalcNextRound();

func CalcCellState(neighboorHp:float) -> DataStruct.CellState:
	if neighboorHp > NeighboorLessLiveMoreDie:	
		return DataStruct.CellState.DYING;
	elif neighboorHp > NeighboorLessKeepMoreLive:
		return DataStruct.CellState.LIVING;
	elif neighboorHp > NeighboorLessDieMoreKeep:
		return DataStruct.CellState.KEEP;
	else:
		return DataStruct.CellState.DYING;

func SetCellStateInMatrix(x: int, y: int, willLive: bool = true) -> bool:
	return Matrix.SetCellStateInMatrix(x, y, willLive);	
