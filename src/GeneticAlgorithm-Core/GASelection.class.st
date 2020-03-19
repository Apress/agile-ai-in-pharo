Class {
	#name : #GASelection,
	#superclass : #Object,
	#instVars : [
		'population',
		'fittest',
		'initialPopulation',
		'fitnessBlock',
		'populationSize',
		'compareFitness',
		'engine'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GASelection >> checkIfEngineSet [
	self assert: [ engine notNil ] description: 'Should set the engine'.
]

{ #category : #'as yet unclassified' }
GASelection >> checkIfInitialPopulationSet [
	self assert: [ initialPopulation notNil ] 
		description: 'Should set the initial population'.
	self assert: [ initialPopulation isCollection ] 
		description: 'Has to be a collection'.
	self assert: [ initialPopulation notEmpty ] 
		description: 'Cannot be empty'
]

{ #category : #'as yet unclassified' }
GASelection >> compareFitness: aTwoArgBlock [
	"Take as argument a two-argument block that compares the fitness of two individuals"
	compareFitness := aTwoArgBlock
]

{ #category : #'as yet unclassified' }
GASelection >> createNewPopulation [
	"Create a new population"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GASelection >> crossover: partnerA with: partnerB [
	"Return one child, result of the crossover over the two arguments"
	^ engine crossover: partnerA with: partnerB
]

{ #category : #'as yet unclassified' }
GASelection >> doSelection [
	"Produce a new population using the selection algorithm"
    self checkIfEngineSet.
    self checkIfInitialPopulationSet.
    populationSize := initialPopulation size.
    fittest := initialPopulation first.
    initialPopulation
        do: [ :ind | 
            ind computeFitnessUsing: fitnessBlock.
            (self isIndividual: ind betterThan: fittest)
                ifTrue: [ fittest := ind ] ].
    self createNewPopulation.
    initialPopulation := population.
]

{ #category : #'as yet unclassified' }
GASelection >> engine [
	"Return the GAEngine to which the selection is associated to"
	^ engine
]

{ #category : #'as yet unclassified' }
GASelection >> engine: theEngine [
	"Set the GAEntine to which I have to be associated with"
	engine := theEngine.
	self checkIfEngineSet
]

{ #category : #'as yet unclassified' }
GASelection >> fitnessBlock [
	"Return the one-arg block used to compute fitness of each individual"
	^ fitnessBlock
]

{ #category : #'as yet unclassified' }
GASelection >> fitnessBlock: aOneArgBlock [
	"The argument is evaluated on the genes of each individual.
	The block argument has to compute the fitness."
	fitnessBlock := aOneArgBlock
]

{ #category : #'as yet unclassified' }
GASelection >> fittest [
	"Return the fittest individual from the new population"
	^ fittest
]

{ #category : #'as yet unclassified' }
GASelection >> initialPopulation: aPopulationAsIndividuals [
	"Set the initial population. This is used to create the new population"
	initialPopulation := aPopulationAsIndividuals.
	self checkIfInitialPopulationSet
]

{ #category : #'as yet unclassified' }
GASelection >> initialize [
	super initialize.
	population := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
GASelection >> isIndividual: ind betterThan: fittestIndividual [
	"Is the first individual better than the second?"
	^ engine isIndividual: ind betterThan: fittestIndividual
]

{ #category : #'as yet unclassified' }
GASelection >> mutate: child [
	"Perform a mutation on the argument"
	^ engine mutate: child
]

{ #category : #'as yet unclassified' }
GASelection >> population [
	"Return the new population"
	^ population
]

{ #category : #'as yet unclassified' }
GASelection >> populationSize [
	"Return the population size"
	^ initialPopulation size
]

{ #category : #'as yet unclassified' }
GASelection >> populationSize: anInteger [
	"Set the population size"
	populationSize := anInteger
]

{ #category : #'as yet unclassified' }
GASelection >> randomNumber: value [
	"Return a number between 1 and value"
	^ engine randomNumber: value
]
