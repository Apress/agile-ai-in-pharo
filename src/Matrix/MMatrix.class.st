Class {
	#name : #MMatrix,
	#superclass : #Object,
	#instVars : [
		'nbRows',
		'nbColumns',
		'array'
	],
	#category : #Matrix
}

{ #category : #'as yet unclassified' }
MMatrix class >> newFromArrays: arrays [
	"Create a matrix from an array containing the structured 
	values of the matrix. Example of matrix creations:
	MMatrix newFromArrays: #(#(1 2 3) #(4 5 6))
	MMatrix newFromArrays: #(#(1 2 3))
	MMatrix newFromArrays: #(#(1) #(2) #(3))
	"
	^ self basicNew
		initializeRows: arrays size columns: arrays first size;
		fromContents: (arrays flatCollect: #yourself);
		yourself
]

{ #category : #'as yet unclassified' }
MMatrix class >> newFromVector: array [
	"Create a Nx1 matrix from an array of numbers (N = array size)"
	^ self basicNew
		initializeRows: array size columns: 1;
		fromContents: array;
		yourself
]

{ #category : #'as yet unclassified' }
MMatrix class >> newHandle: aHandle rows: numRows columns: numColumns [
	"Create a matrix with a provided content. Useful when creating a matrix after an FFI operation"
	^ self basicNew
		initializeHandle: aHandle rows: numRows columns: numColumns;
		yourself
]

{ #category : #'as yet unclassified' }
MMatrix class >> newRows: numRows columns: numColumns [
	"Create a matrix with a given shape"
	^ self basicNew
		initializeRows: numRows columns: numColumns;
		yourself
]

{ #category : #'as yet unclassified' }
MMatrix >> * aFactor [
	"Multiply each element of the matrix by a factor"
	^ self collect: [ :v | v * aFactor ]
]

{ #category : #'as yet unclassified' }
MMatrix >> + matrixOrVector [
	"Add either a matrix or a vector to the receiver. 
	The argument could either be a matrix of the same size or a vector
	A new matrix is returned as result"
	| m |
	((nbRows = matrixOrVector nbRows) and: [ nbColumns = matrixOrVector nbColumns ])
		ifTrue: [ ^ self add: matrixOrVector ].
	matrixOrVector nbColumns ~= 1 ifTrue: [ self error: 'not a n * 1 vector' ].
	m := matrixOrVector stretchToColumns: nbColumns.
	^ self + m
]

{ #category : #'as yet unclassified' }
MMatrix >> +* anotherMatrix [
	"Shortcut for the dot operator between matrices"
	^ self dot: anotherMatrix 
]

{ #category : #'as yet unclassified' }
MMatrix >> - anotherMatrix [
	"Substract a matrix from the receiver matrix"
	^ self sub: anotherMatrix
]

{ #category : #'as yet unclassified' }
MMatrix >> / value [
	"Divide each element of the matrix by a value"
	^ self collect: [ :v | v / value ]
]

{ #category : #'as yet unclassified' }
MMatrix >> add: aMatrix [
	"Add two matrices, the receiver and the argument, and produces a new matrix"
	| result resultArray |
	nbColumns = aMatrix nbColumns ifFalse: [self error: 'dimensions do not conform'].
	nbRows = aMatrix nbRows ifFalse: [self error: 'dimensions do not conform'].
	
	resultArray := ByteArray new: (nbRows * aMatrix nbColumns * 8).
	self assert: [ nbRows * nbColumns = array size ].
	self assert: [ aMatrix nbRows * aMatrix nbColumns = aMatrix size ].
	self assert: [ nbRows * aMatrix nbColumns * 8 = resultArray size ].
	self 
		add: self getHandle with: nbRows with: nbColumns with: aMatrix getHandle
		in: resultArray.
	result := MMatrix newHandle: resultArray rows: nbRows columns: nbColumns.
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> add: m1 with: nb_rows with: nb_columns with: m2 in: res [
	^ self 
		ffiCall: #(void add(double *m1, int nb_rows, int nb_columns, 
              	double *m2, 
              	double *res)) 
		module: 'matrix.dylib'
]

{ #category : #'as yet unclassified' }
MMatrix >> array [
	"The array containing matrix' values"
	^ array
]

{ #category : #'as yet unclassified' }
MMatrix >> asArray [
	"Return a linear array of the matrix values"
	^ array asArray
]

{ #category : #'as yet unclassified' }
MMatrix >> asStructuredArray [
	"Return a structured array that describe the matrix"
	^ (1 to: nbRows) collect: [ :i | self atRow: i ] as: Array
]

{ #category : #'as yet unclassified' }
MMatrix >> at: aPoint [
	"Access an element of the matrix"
	^ array at: ((aPoint x - 1) * nbColumns + (aPoint y - 1)) + 1
]

{ #category : #'as yet unclassified' }
MMatrix >> at: aPoint put: aNumber [
	"Modify an element of the matrix"
	array at: ((aPoint x - 1) * nbColumns + (aPoint y - 1)) + 1 put: aNumber asFloat
]

{ #category : #'as yet unclassified' }
MMatrix >> atRow: rowNumber [
	"Return a particular row"
	(rowNumber between: 1 and: rowNumber)
		ifFalse: [ self error: 'index out of range' ].
	^ (1 to: nbColumns) collect: [ :x | self at: rowNumber @ x ] 
]

{ #category : #'as yet unclassified' }
MMatrix >> collect: aOneArgBlock [
	"Return a new matrix, for which each matrix element is transformed using the provided block"
	| result |
	result := MMatrix newRows: nbRows columns: nbColumns.
	1 to: nbRows do: [ :y |
		1 to: nbColumns do: [ :x |
			result at: y @ x put: (aOneArgBlock value: (self at: y @ x))
		] ].
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> dot: anotherMatrix [
	"Compute the dot product between the receiving matrix and the argument"
	| result resultArray |
	nbColumns = anotherMatrix nbRows ifFalse: [self error: 'dimensions do not conform'].
	self assert: [ nbRows * nbColumns = array size ].
	self assert: [ anotherMatrix nbRows * anotherMatrix nbColumns = anotherMatrix  size ].
	resultArray := ByteArray new: (nbRows * anotherMatrix nbColumns * 8).
	
	self 
		dot: self getHandle with: nbRows with: nbColumns 
		with: anotherMatrix getHandle
		with: anotherMatrix nbRows with: anotherMatrix nbColumns in: resultArray.

	result := MMatrix 
		newHandle: resultArray 
		rows: nbRows 
		columns: anotherMatrix nbColumns.
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> dot: array1 with: m1_nb_rows with: m1_nb_columns with: array2 with: m2_nb_rows with: m2_nb_columns in: res [
	"Invoke the C library to perform the dot operator"
	^ self 
		ffiCall: #(void dot(
			void *array1, int m1_nb_rows, int m1_nb_columns, 
         	void *array2, int m2_nb_rows, int m2_nb_columns, void *res) ) 
		module: 'matrix.dylib'
]

{ #category : #'as yet unclassified' }
MMatrix >> fromContents: content [
	"Initialize the matrix with a linear content"
	self assert: [ content size = (nbColumns * nbRows) ] description: 'size mismatch'.
	content doWithIndex: [ :v :i | array at: i put: v ]
]

{ #category : #'as yet unclassified' }
MMatrix >> getHandle [
	"Return the handle of the foreign object. 
	This allows the array to be accessed from C"
	^ array getHandle
]

{ #category : #'as yet unclassified' }
MMatrix >> initializeHandle: aHandle rows: numRows columns: numColumns [
	"Initialize the matrix"
	self initialize.
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArrayFromHandle: aHandle
]

{ #category : #'as yet unclassified' }
MMatrix >> initializeRows: numRows columns: numColumns [
	self initialize.
	nbRows := numRows.
	nbColumns := numColumns.
	array := self newArray
]

{ #category : #'as yet unclassified' }
MMatrix >> max [
	"Return the maximum value of the matrix"
	^ self asArray max
]

{ #category : #'as yet unclassified' }
MMatrix >> multiplyPerElement: mat [
	"Multiply two matrices element-wise"
	| r |
	self assert: [ nbRows = mat nbRows ].
	self assert: [ nbColumns = mat nbColumns ].
	r := MMatrix newRows: nbRows columns: nbColumns.
	r fromContents: (self asArray with: mat array asArray collect: [ :a :b | a * b ]).
	^ r
]

{ #category : #'as yet unclassified' }
MMatrix >> nbColumns [
	"Number of columns defined in the matrix"
	^ nbColumns
]

{ #category : #'as yet unclassified' }
MMatrix >> nbRows [
	"Number of rows defined in the matrix"
	^ nbRows
]

{ #category : #'as yet unclassified' }
MMatrix >> newArray [
	"Create an array used to contains the store the matrix content"
	^ FFIExternalArray 
		newType: 'double' 
		size: nbColumns * nbRows
]

{ #category : #'as yet unclassified' }
MMatrix >> newArrayFromHandle: aHandle [
	"Create an external array using a handle"
	^ FFIExternalArray 
		fromHandle: aHandle 
		type: 'double' 
		size: nbColumns * nbRows
]

{ #category : #'as yet unclassified' }
MMatrix >> printOn: aStream [
	"Print the matrix in the stream, with 4 decimal for each value"
	self printOn: aStream round: 4
]

{ #category : #'as yet unclassified' }
MMatrix >> printOn: aStream round: nbDecimals [
	"Print the receiver matrix into a stream. All numerical value are truncated to a fixed number of decimals"
	aStream nextPutAll: '('.
	(1 to: nbRows) 
		do: [ :r | 
				(self atRow: r) 
					do: [ :each | aStream nextPutAll: (each round: nbDecimals) printString ] 
					separatedBy: [ aStream space ]]
		separatedBy: [ aStream cr ].
	aStream nextPutAll: ' )'.
]

{ #category : #'as yet unclassified' }
MMatrix >> random [
	"Fill the matrix with random numbers"
	^ self random: Random new
]

{ #category : #'as yet unclassified' }
MMatrix >> random: randomNumberGenerator [
	"Fill the matrix with random numbers. Takes a random number generator as argument"
	self fromContents: ((1 to: nbRows * nbColumns) collect: [ :vv | randomNumberGenerator next ])
]

{ #category : #'as yet unclassified' }
MMatrix >> size [
	"The number of values contained in the matrix"
	^ nbColumns * nbRows 
]

{ #category : #'as yet unclassified' }
MMatrix >> stretchToColumns: nbOfColumns [
	"Stretch a vertical vector in a column."
	| content result |
	content := OrderedCollection new.
	1 to: nbRows do: [ :row |
		1 to: nbOfColumns do: [ :columns |
			content add: (self at: row @ 1) ] ].
	result := MMatrix newRows: nbRows columns: nbOfColumns.
	result fromContents: content.
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> sub: anotherMatrix [
	| result resultArray |
	nbColumns = anotherMatrix nbColumns ifFalse: [self error: 'dimensions do not conform'].
	nbRows = anotherMatrix nbRows ifFalse: [self error: 'dimensions do not conform'].
	
	resultArray := ByteArray new: (nbRows * anotherMatrix nbColumns * 8).
	
	self assert: [ nbRows * nbColumns = array size ].
	self assert: [ anotherMatrix nbRows * anotherMatrix nbColumns = anotherMatrix  size ].
	self assert: [ nbRows * anotherMatrix nbColumns * 8 = resultArray size ].
	
	self 
		sub: self getHandle with: nbRows with: nbColumns with: anotherMatrix getHandle
		in: resultArray.
	result := MMatrix newHandle: resultArray rows: nbRows columns: nbColumns.
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> sub: m1 with: nb_rows with: nb_columns with: m2 in: res [
	^ self 
		ffiCall: #(void sub(double *m1, int nb_rows, int nb_columns, 
              	double *m2, double *res)) 
		module: 'matrix.dylib'
]

{ #category : #'as yet unclassified' }
MMatrix >> sum [
	"Return the sum of the matrix values"
	| sum |
	sum := 0.
	1 to: nbRows do: [ :y |
		1 to: nbColumns do: [ :x |
			sum := sum + (self at: y @ x)
		] 
	].
	^ sum
]

{ #category : #'as yet unclassified' }
MMatrix >> sumHorizontal [
	"Horizontal summing"
	| result sum |
	result := MMatrix newRows: nbRows columns: 1.
	1 to: nbRows do: [ :y |
		sum := 0.
		1 to: nbColumns do: [ :x |
			sum := sum + (self at: y @ x) ].
		result at: y @ 1 put: sum ].
	^ result
]

{ #category : #'as yet unclassified' }
MMatrix >> transposed [
	"Transpose the matrix"
	| result |
	result := MMatrix newRows: nbColumns columns: nbRows.
	1 to: nbRows do: [ :row |
		1 to: nbColumns do: [ :column |
			result at: column @ row put: (self at: row @ column)
		]
	].
	^ result
]
