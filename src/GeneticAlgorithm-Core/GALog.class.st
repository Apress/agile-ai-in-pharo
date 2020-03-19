Class {
	#name : #GALog,
	#superclass : #Object,
	#instVars : [
		'generationNumber',
		'timeToProduceGeneration',
		'fittestIndividual',
		'worseFitness',
		'averageFitness',
		'time'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GALog >> averageFitness [
	"Return the average fitness value of a generation I am representing"
	^ averageFitness
]

{ #category : #'as yet unclassified' }
GALog >> averageFitness: aNumber [
	"Set the average fitness value of a generation I am representing"
	averageFitness := aNumber
]

{ #category : #'as yet unclassified' }
GALog >> bestFitness [
	"Return the best fitness value of a generation I am representing"
	^ fittestIndividual fitness
]

{ #category : #'as yet unclassified' }
GALog >> fittestIndividual [
	"Return the best individual of the generation I represent"
	^ fittestIndividual
]

{ #category : #'as yet unclassified' }
GALog >> fittestIndividual: anIndividual [
	"Set the best individual of the generation I represent"
	fittestIndividual := anIndividual
]

{ #category : #'as yet unclassified' }
GALog >> generationNumber [
	"Return the generation number I represent"
	^ generationNumber
]

{ #category : #'as yet unclassified' }
GALog >> generationNumber: generationNumberAsInteger [
	"Set the generation number I am representing"
	generationNumber := generationNumberAsInteger
]

{ #category : #'as yet unclassified' }
GALog >> initialize [
	super initialize.
	time := DateAndTime now
]

{ #category : #'as yet unclassified' }
GALog >> printOn: str [
	"Printing the log object"
	super printOn: str.
	str nextPut: $<.
	str nextPutAll: fittestIndividual genes asString.
	str nextPut: $>.
]

{ #category : #'as yet unclassified' }
GALog >> time [
	"Return the time the log was created"
	^ time
]

{ #category : #'as yet unclassified' }
GALog >> timeToProduceGeneration [
	"Time to produce the generation I represent"
	^ timeToProduceGeneration
]

{ #category : #'as yet unclassified' }
GALog >> timeToProduceGeneration: anInteger [
	"Set the time to produce the generation I am representing"
	timeToProduceGeneration := anInteger
]

{ #category : #'as yet unclassified' }
GALog >> worseFitness [
	"Return the worse fitness value of a generation I am representing"
	^ worseFitness
]

{ #category : #'as yet unclassified' }
GALog >> worseFitness: aNumber [
	"Set the worst fitness value of a generation I am representing"
	worseFitness := aNumber
]
