Class {
	#name : #GAConstrainedCrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#instVars : [
		'possibleCutpoints'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAConstrainedCrossoverOperation >> pickCutPointFor: partnerA [
	"Return a cutpoint"
	self assert: [ possibleCutpoints notNil ] description: 
		'Need to provide the possible cut points, using #possibleCutpoints:'.
	^ possibleCutpoints at: (random nextInt: possibleCutpoints size)
]

{ #category : #'as yet unclassified' }
GAConstrainedCrossoverOperation >> possibleCutpoints: indexes [
	"Set the possible pointcuts considered by the operator"
	possibleCutpoints := indexes
]
