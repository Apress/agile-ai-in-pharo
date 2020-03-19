Class {
	#name : #Normalization,
	#superclass : #Object,
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
Normalization >> normalizeData: aCollectionOfTrainingDataWithExpectedOutput [
	"Normalize the data provided as argument"
	
	| nbOfColumns min max |
	"We exclude the expected output"
	nbOfColumns := aCollectionOfTrainingDataWithExpectedOutput first size - 1.
	
	min := OrderedCollection new.
	max := OrderedCollection new.
	1 to: nbOfColumns do: [ :index |
		| column |
		column := aCollectionOfTrainingDataWithExpectedOutput collect: [ :row | row at: index ].
		min add: column min.
		max add: column max ].

	^ self normalizeData: aCollectionOfTrainingDataWithExpectedOutput min: min max: max
]

{ #category : #'as yet unclassified' }
Normalization >> normalizeData: aCollectionOfTrainingDataWithExpectedOutput min: minimumValues max: maximumValues [
	| nbOfColumns result mn mx |
	nbOfColumns := aCollectionOfTrainingDataWithExpectedOutput first size - 1.

	result := OrderedCollection new.
	aCollectionOfTrainingDataWithExpectedOutput do: [ :row |
		| t v |
		t := OrderedCollection new.
		1 to: nbOfColumns do: [ :index |
			v := row at: index.
			mn := minimumValues at: index.
			mx := maximumValues at: index.
			t add: ((v - mn) / (mx - mn)) asFloat
		].
		t add: row last.
		result add: t asArray ].
	^ result asArray
]
