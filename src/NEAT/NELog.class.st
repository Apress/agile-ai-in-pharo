Class {
	#name : #NELog,
	#superclass : #Object,
	#instVars : [
		'generation',
		'speciation',
		'minFitness',
		'maxFitness',
		'averageFitness',
		'bestIndividual'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NELog >> averageFitness [
	"Return the average population fitness"
	^ averageFitness
]

{ #category : #'as yet unclassified' }
NELog >> averageFitness: aNumber [
	"Set the average population fitness"
	averageFitness := aNumber
]

{ #category : #'as yet unclassified' }
NELog >> bestIndividual [
	"Return the best individual of the population"
	^ bestIndividual
]

{ #category : #'as yet unclassified' }
NELog >> bestIndividual: anIndividual [
	"Set the best individual of the population"
	bestIndividual := anIndividual
]

{ #category : #'as yet unclassified' }
NELog >> generation [
	"Return the generation number represented by the log"
	^ generation
]

{ #category : #'as yet unclassified' }
NELog >> generation: anInteger [
	"Set the generation number"
	generation := anInteger
]

{ #category : #'as yet unclassified' }
NELog >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: [ speciation visualize ]
]

{ #category : #'as yet unclassified' }
NELog >> maxFitness [
	"Return the maximum fitness"
	^ maxFitness
]

{ #category : #'as yet unclassified' }
NELog >> maxFitness: aNumber [
	"Set the maximum fitness"
	maxFitness := aNumber
]

{ #category : #'as yet unclassified' }
NELog >> minFitness [
	"Return the minimum fitness"
	^ minFitness
]

{ #category : #'as yet unclassified' }
NELog >> minFitness: aNumber [
	"Set the minimum fitness"
	minFitness := aNumber
]

{ #category : #'as yet unclassified' }
NELog >> numberOfSpecies [
	"Return the number of species in the speciation"
	speciation ifNil: [ ^ 0 ].
	^ speciation numberOfSpecies
]

{ #category : #'as yet unclassified' }
NELog >> release [
	"Release the specification, and thus reduce the amount of consumed memory"
	speciation := nil.
	bestIndividual := nil
]

{ #category : #'as yet unclassified' }
NELog >> speciation [
	"Return the speciation of the generation represented by the log"
	^ speciation
]

{ #category : #'as yet unclassified' }
NELog >> speciation: aSpeciation [
	"Set the speciation"
	speciation := aSpeciation
]
