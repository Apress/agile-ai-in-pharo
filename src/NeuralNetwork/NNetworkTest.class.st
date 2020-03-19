Class {
	#name : #NNetworkTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
NNetworkTest >> testBasic [
    | n |
    n := NNetwork new.
    n configure: 2 hidden: 2 nbOfOutputs: 1.
    self assert: ((n feed: #(1 3)) anyOne closeTo: 0.6745388083637036 precision: 0.0000000001).
    self assert: n numberOfOutputs equals: 1
]

{ #category : #'as yet unclassified' }
NNetworkTest >> testXOR [
	| n |
	n := NNetwork new.
	n configure: 2 hidden: 3 nbOfOutputs: 1.

	20000 timesRepeat: [ 
		n train: #(0 0) desiredOutputs: #(0).	
		n train: #(0 1) desiredOutputs: #(1).
		n train: #(1 0) desiredOutputs: #(1).
		n train: #(1 1) desiredOutputs: #(0).
	].

	self assert: (n feed: #(0 0)) first < 0.1.
	self assert: (n feed: #(0 1)) first > 0.9.
	self assert: (n feed: #(1 0)) first > 0.9.
	self assert: (n feed: #(1 1)) first < 0.1.
]
