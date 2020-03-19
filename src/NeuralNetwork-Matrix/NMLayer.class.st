Class {
	#name : #NMLayer,
	#superclass : #Object,
	#instVars : [
		'w',
		'b',
		'delta',
		'output',
		'previous',
		'next',
		'lr',
		'numberOfExamples'
	],
	#category : #'NeuralNetwork-Matrix'
}

{ #category : #'as yet unclassified' }
NMLayer >> b [
	"Return the bias vector"
	^ b
]

{ #category : #'as yet unclassified' }
NMLayer >> b: biasVector [
	"Set a vector, instance of MMatrix, as the bias vector"
	b := biasVector
]

{ #category : #'as yet unclassified' }
NMLayer >> delta [
	^ delta
]

{ #category : #'as yet unclassified' }
NMLayer >> delta: deltaMatrix [
	delta := deltaMatrix
]

{ #category : #'as yet unclassified' }
NMLayer >> feed: inputMatrix [
	"Feed the layer with the input matrix"
	output := (w +* inputMatrix + b) collect: [ :v | 1 / (1 + v negated exp) ].
	^ output
]

{ #category : #'as yet unclassified' }
NMLayer >> initialize [
	super initialize.
	lr := 0.1
]

{ #category : #'as yet unclassified' }
NMLayer >> lr: aLearningRate [
	lr := aLearningRate
]

{ #category : #'as yet unclassified' }
NMLayer >> nbInputs: nbOfInputs nbOutputs: nbOfOutputs random: random [
	"Initialize the layer"
	w := MMatrix newRows: nbOfOutputs columns: nbOfInputs.
	w random: random.
	b := MMatrix newRows: nbOfOutputs columns: 1.
	b random: random.
]

{ #category : #'as yet unclassified' }
NMLayer >> next [
	"Return the next layer"
	^ next
]

{ #category : #'as yet unclassified' }
NMLayer >> next: aLayer [
	"Set the next layer"
	next := aLayer
]

{ #category : #'as yet unclassified' }
NMLayer >> numberOfExamples [
	^ numberOfExamples
]

{ #category : #'as yet unclassified' }
NMLayer >> numberOfExamples: aNumber [
	numberOfExamples := aNumber
]

{ #category : #'as yet unclassified' }
NMLayer >> output [
	"Return the output matrix, computed during the feed forward phase"
	^ output
]

{ #category : #'as yet unclassified' }
NMLayer >> previous [
	"Return the previous layer"
	^ previous
]

{ #category : #'as yet unclassified' }
NMLayer >> previous: aLayer [
	"Set the previous layer"
	previous := aLayer
]

{ #category : #'as yet unclassified' }
NMLayer >> update [
	"Update the weights and biases using the delta value"
	w := w - ((delta +* previous output transposed) * lr / numberOfExamples).
	b := b - (delta sumHorizontal * lr / numberOfExamples).
	next ifNotNil: [ next update ]
]

{ #category : #'as yet unclassified' }
NMLayer >> update: input [
	"Update the weights and biases using the input value"
	w := w - ((delta +* input transposed) * lr / numberOfExamples).
	b := b - (delta sumHorizontal * lr / numberOfExamples).
	next update
]

{ #category : #'as yet unclassified' }
NMLayer >> w [
	"Return the MMatrix representing the weights"
	^ w
]

{ #category : #'as yet unclassified' }
NMLayer >> w: matrixForWeights [
	"Take a MMatrix as argument"
	w := matrixForWeights
]
