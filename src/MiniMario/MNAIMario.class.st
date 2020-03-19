Class {
	#name : #MNAIMario,
	#superclass : #MNMario,
	#instVars : [
		'network'
	],
	#category : #MiniMario
}

{ #category : #'as yet unclassified' }
MNAIMario >> beat [
	| actionToPerform |
	super beat.
	actionToPerform := network predict: game whatMarioSees.
	actionToPerform = 0 ifTrue: [ self moveLeft ].
	actionToPerform = 1 ifTrue: [ self moveRight ].
	actionToPerform = 2 ifTrue: [ self jump ].
]

{ #category : #'as yet unclassified' }
MNAIMario >> network: aNeuralNetwork [
	"Set the neural network meant to be used by Mario"
	network := aNeuralNetwork
]
