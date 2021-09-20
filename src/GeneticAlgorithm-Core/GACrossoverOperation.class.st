Class {
	#name : #GACrossoverOperation,
	#superclass : #GAAbstractCrossoverOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GACrossoverOperation >> pickCutPointFor: partnerA [

	"Simply returns a random number between 1 and the number of genes of the individual provided as argument"

	^ random nextInteger: partnerA numberOfGenes
]
