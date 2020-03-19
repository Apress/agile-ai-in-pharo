Class {
	#name : #GAMutationOperation,
	#superclass : #GAAbstractMutationOperation,
	#instVars : [
		'geneFactoryBlock'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAMutationOperation >> checkForGeneFactory [
	self
		assert: [ geneFactoryBlock notNil ]
		description: 'Need to provide a block to create gene'
]

{ #category : #'as yet unclassified' }
GAMutationOperation >> doMutate: individual [
	"Mutate genes of the argument"
	self checkForRandomNumber.
	self checkForGeneFactory.
	1 to: individual genes size do: [ :index | 
		self randomNumber <= mutationRate
			ifTrue: [ individual genes at: index put: (geneFactoryBlock cull: random cull: index cull: individual) ] ]	
]

{ #category : #'as yet unclassified' }
GAMutationOperation >> geneFactoryBlock [
	"Return the three-arg block used to create a gene, following the pattern
	[ :rand :index :ind | ... ]
	rand is the random number generator, 
	index is index of the gene,
	ind is the individual being filled"

	^ geneFactoryBlock
]

{ #category : #'as yet unclassified' }
GAMutationOperation >> geneFactoryBlock: oneArgBlock [
	"The block receive a random number as argument"
	geneFactoryBlock := oneArgBlock
]
