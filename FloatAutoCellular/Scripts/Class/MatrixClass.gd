extends Node

# In order to reduce the performance loss caused by multiple function calls,
# I concentrated the functionality into a few functions, I admit it looks ugly...

class_name FloatAutoCellularMatrix

var MatrixWidth: int;
var MatrixLength: int;

var CellStateMatrix: Array;

var CalcFloatMatrix: Array;
var AnimFloatMatrix: Array;

var IsKeepMeansKeepCellHp:bool = true;
#var CellHpChangeMatrix: Array;

var rng:RandomNumberGenerator;

func SetKeepMean(isKeepMeansKeepCellHp: bool) -> void:
	IsKeepMeansKeepCellHp = isKeepMeansKeepCellHp;

func InitMatrix(matrixWidth: int, matrixLength: int, p:int = 15) -> void:
	rng = RandomNumberGenerator.new();
	MatrixWidth = matrixWidth + 2;
	MatrixLength = matrixLength + 2;
	for x in range(MatrixWidth):
		CalcFloatMatrix.append([]);
		AnimFloatMatrix.append([]);
		CellStateMatrix.append([]);
		#CellHpChangeMatrix.append([]);
		for y in range(MatrixLength):
			CalcFloatMatrix[x].append(0);
			AnimFloatMatrix[x].append(0);
			CellStateMatrix[x].append(DataStruct.CellState.DIE);	
			#CellHpChangeMatrix[x].append(false);
	RandomMatrix(p);
	
func RandomMatrix(p: int) -> void:
	var randomInt:int;
	for x in range(1, MatrixWidth - 1):
		for y in range(1, MatrixLength - 1):
			randomInt = rng.randi_range(0, 99);
			#CellHpChangeMatrix[x][y] = true;
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
				#CellHpChangeMatrix[x][y] = true;
			elif currentCellState == DataStruct.CellState.DYING:
				currentHp = CalcFloatMatrix[x][y] - cellHpDownValue;
				if currentHp < 0:
					currentHp = 0;
				AnimFloatMatrix[x][y] = currentHp;
				#CellHpChangeMatrix[x][y] = true;
			#elif currentCellState == DataStruct.CellState.KEEP:
				#CellHpChangeMatrix[x][y] = true;
			#else:
				#CellHpChangeMatrix[x][y] = false;

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
			currentCellState = MatrixVariable.CalcCellState(neighboorsHP);
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
				#CellHpChangeMatrix[x][y] = true;
				AnimFloatMatrix[x][y] = currentHp;
				CalcFloatMatrix[x][y] = currentHp;
			#else:
				#CellHpChangeMatrix[x][y] = false;
				


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
