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

func InitDefaultRules() -> void:
	SetKeepMean(true);
	InitTimerValue(1, 1, 1)
	Matrix.NeighboorLessLiveMoreDie = 3.5
	Matrix.NeighboorLessKeepMoreLive = 2.5
	Matrix.NeighboorLessDieMoreKeep = 1.5
####################################################################################################
#Rule
func SetKeepMean(isKeepMeansKeepCellHp:bool) -> void:
	Matrix.SetKeepMean(isKeepMeansKeepCellHp);
func InitNeighboorLessLiveMoreDieValue(value: float) -> bool:
	return Matrix.InitNeighboorLessLiveMoreDieValue(value);
func InitNeighboorLessKeepMoreLiveValue(value: float) -> bool:
	return Matrix.InitNeighboorLessKeepMoreLiveValue(value);
func InitNeighboorLessDieMoreKeepValue(value: float) -> bool:
	return Matrix.InitNeighboorLessDieMoreKeepValue(value);
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

func SetCellStateInMatrix(x: int, y: int, willLive: bool = true) -> bool:
	return Matrix.SetCellStateInMatrix(x, y, willLive);	
