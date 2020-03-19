Class {
	#name : #ActivationFunction,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
ActivationFunction >> derivative: output [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
ActivationFunction >> eval: z [
	^ self subclassResponsibility
]
