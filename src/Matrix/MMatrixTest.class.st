Class {
	#name : #MMatrixTest,
	#superclass : #TestCase,
	#category : #Matrix
}

{ #category : #'as yet unclassified' }
MMatrixTest >> testAddition1 [
	| m1 m2 |
	m1 := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)). 
	m2 := MMatrix newFromArrays: #(#(4 5 6) #(1 2 3)).
	self assert: (m1 + m2) asStructuredArray equals: #(#(5.0 7.0 9.0) #(5.0 7.0 9.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testAddition2 [
	| m |
	m := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)). 
	self assert: (m + m) asStructuredArray equals: #(#(2.0 4.0 6.0) #(8.0 10.0 12.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testAt [
	| m |
	m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
	self assert: (m at: 1 @ 1) equals: 1.
	self assert: (m at: 1 @ 2) equals: 2.
	self assert: (m at: 2 @ 1) equals: 3.
	self assert: (m at: 2 @ 2) equals: 4.
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testAtPut [
	| m |
	m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
	m at: 2 @ 1 put: 10.0.
	self assert: (m at: 2 @ 1) equals: 10.0.
	self assert: m asStructuredArray equals: #(#(1 2) #(10 4))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testCollect [
	| m expectedMatrix |
	m := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)).
	expectedMatrix := MMatrix newFromArrays: #(#(2 3 4) #(5 6 7)).
	self assert: (m collect: [ :v | v + 1]) asStructuredArray equals: expectedMatrix asStructuredArray
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testCreation [
	| m |
	m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
	self assert: m asArray equals: #(1.0 2.0 3.0 4.0)
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testDivision [
	| m |
	m := MMatrix newFromArrays: #(#(1 2 3) #(4 5 6)). 
	self assert: (m / 2) asStructuredArray equals: #(#(0.5 1.0 1.5) #(2.0 2.5 3.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testMatrixProduct [
	| m1 m2 |
	m1 := MMatrix newFromArrays: #(#(1 2 3 4) #(5 6 7 8)).
	m2 := MMatrix newFromArrays: #(#(1 2) #(3 4) #(5 6) #(7 8)).
	self assert: (m1 +* m2) asStructuredArray equals: #(#(50.0 60.0) #(114.0 140.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testMax [
	| m |
	m := MMatrix newFromArrays: #(#(1 2) #(3 4)).
	self assert: m max equals: 4.
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testMultiplicationOnMatrix [
	| x |
	x := MMatrix newFromArrays: #(#(1 2 3 4) #(10 20 30 40)).
	self assert: (x * 5) asStructuredArray 
			equals: #(#(5.0 10.0 15.0 20.0) #(50.0 100.0 150.0 200.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testMultiplicationOnVector [
	| x |
	x := MMatrix newFromVector: #(1 2 3 4).
	self assert: (x * 5) asStructuredArray equals: #(#(5.0) #(10.0) #(15.0) #(20.0))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testMultiplicationPerElement [
	| v1 v2 expectedVector |
	v1 := MMatrix newFromVector: #(1 2 3).
	v2 := MMatrix newFromVector: #(10 20 30).
	expectedVector := MMatrix newFromVector: #(10 40 90).
	self assert: (v1 multiplyPerElement: v2) asArray 
			equals: expectedVector asArray
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testStretching [
	| m |
	m := (MMatrix newFromVector: #(1 2 3 4)) stretchToColumns: 5. 
	self assert: m nbRows equals: 4.
	self assert: m nbColumns equals: 5.
	self assert: (m atRow: 1) equals: #(1 1 1 1 1).
	self assert: (m atRow: 3) equals: #(3 3 3 3 3).
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testSub [
	| m1 m2 |
	m1 := MMatrix newFromArrays: #(#(1 2 3 4) #(5 6 7 8)).
	m2 := MMatrix newFromArrays: #(#(4 2 1 3) #(7 6 8 5)).
	self assert: (m1 - m2) asStructuredArray equals: #(#(-3 0 2 1) #(-2 0 -1 3))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testSum [
	| m |
	m := MMatrix newFromArrays: #(#(1 2 3 4) #(5 6 7 8)).
	self assert: m sum equals: (1 to: 8) sum
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testSumHorizontal [
	| m expectedResult |
	m := MMatrix newFromArrays: #(#(1.0 2.0) #(3.0 4.0) #(5.0 6.0)).
	expectedResult := MMatrix newFromArrays: #(#(3.0) #(7.0) #(11.0)).
	self assert: m sumHorizontal asStructuredArray equals: expectedResult asStructuredArray
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testTransposedOnMatrix [
	| m expectedResult |
	m := MMatrix newFromArrays: #(#(1 2 3 4) #(5 6 7 8)).
	expectedResult := MMatrix newFromArrays: #(#(1 5) #(2 6) #(3 7) #(4 8)).
	self assert: m transposed asStructuredArray equals: expectedResult asStructuredArray
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testTransposedOnVector [
	| m |
	m := MMatrix newFromVector: #(1 2 3).
	self assert: m transposed asStructuredArray equals: #(#(1 2 3))
]

{ #category : #'as yet unclassified' }
MMatrixTest >> testVectorCreation [
	| v |
	v := MMatrix newFromVector: #(1 2 3).
	self assert: v nbColumns equals: 1.
	self assert: v nbRows equals: 3.
	self assert: v asStructuredArray equals: #(#(1) #(2) #(3))
]
