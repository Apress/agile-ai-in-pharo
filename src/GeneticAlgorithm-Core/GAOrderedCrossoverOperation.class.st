Class {
	#name : #GAOrderedCrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> crossover: individualA with: individualB [
    "Return a new child, which is the result of mixing the two individuals"
 	| i1 i2 |
	i1 := self pickCutPointFor: individualA.
	i2 := self pickCutPointFor: individualA.
	
	"Make sure that i1 is smaller than i2"
	(i1 > i2) ifTrue: [ | t | t := i1. i1 := i2. i2 := t ].
	^ self crossover: individualA with: individualB from: i1 to: i2
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> crossover: individualA with: individualB from: i1 to: i2 [
    "Return a new child, which is the result of mixing myself the two individuals. The method assumes that i1 <= i2."

    | child crossOverGenes runningIndex swath |
    child := GAIndividual new.
    child random: random.

	swath := individualA genes copyFrom: i1 to: i2.
	crossOverGenes := Array new: individualA genes size.
	crossOverGenes := crossOverGenes copyReplaceFrom: i1 to: i2 with: swath.

	runningIndex := 1.
	(individualB genes copyWithoutAll: swath)
		do: [ :v | (crossOverGenes includes: v) ifFalse: [ 
				[(crossOverGenes at: runningIndex) notNil] whileTrue: [ runningIndex := runningIndex + 1 ]. 
				crossOverGenes at: runningIndex put: v ] ].

    child genes: crossOverGenes.
    ^ child
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperation >> pickCutPointFor: partner [
    "Simply return a random number between 1 and the number of genes of the individual provided as argument"
    ^ random nextInt: partner genes size
]
