Class {
	#name : #GAEngine,
	#superclass : #GAObject,
	#instVars : [
		'fitnessBlock',
		'createGeneBlock',
		'numberOfGenes',
		'populationSize',
		'logs',
		'population',
		'terminationBlock',
		'compareFitness',
		'mutationOperator',
		'crossoverOperator',
		'selection',
		'beforeCreatingInitialIndividual'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAEngine >> beforeCreatingInitialIndividual: aOneArgBlock [
	"Set the behavior to be executed before creating an individual.
	The block takes a random number generator as argument."
	beforeCreatingInitialIndividual := aOneArgBlock
]

{ #category : #'as yet unclassified' }
GAEngine >> beforeRun [
    "Method executed before creating the initial population"
    self checkIfReadyToRun.  
    selection fitnessBlock: fitnessBlock.
    selection populationSize: populationSize 
]

{ #category : #'as yet unclassified' }
GAEngine >> checkIfReadyToRun [
	"Raise an exception if the configuration is not ready to be run"
	self assert: [ fitnessBlock notNil ] 
		description: 'Need to set a fitnessBlock'.
	self assert: [ createGeneBlock notNil ] 
		description: 'Need to set a createGeneBlock'.
	self assert: [ numberOfGenes notNil ] 
		description: 'Need to set how many genes you wish to have, using numberOfGenes:'.
	self assert: [ logs isEmpty ] 
		description: 'Already been run'.
]

{ #category : #'as yet unclassified' }
GAEngine >> createGeneBlock: threeArgBlock [
	"Three arguments must be provided rand, index, and the individual being filled"
	createGeneBlock := threeArgBlock.
	mutationOperator geneFactoryBlock: threeArgBlock
]

{ #category : #'as yet unclassified' }
GAEngine >> crossover: partnerA with: partnerB [
	"Perform a crossover operation between the two arguments"
	^ crossoverOperator crossover: partnerA with: partnerB
]

{ #category : #'as yet unclassified' }
GAEngine >> crossoverOperator: aCrossoverOperator [
	"Set the crossover operator used in the algorithm"
	crossoverOperator := aCrossoverOperator.
	crossoverOperator random: random
]

{ #category : #'as yet unclassified' }
GAEngine >> endForMaxNumberOfGeneration: nbOfGenerations [
	"End the algorithm after a fixed number of generations"
	terminationBlock := 
		[ logs last generationNumber >= nbOfGenerations ]
]

{ #category : #'as yet unclassified' }
GAEngine >> endIfFitnessIsAbove: aFitnessValueThreshold [
	"End the algorithm if the best fitness value is above a particular threshold"
	terminationBlock := 
		[ logs last fittestIndividual fitness >= aFitnessValueThreshold ]
]

{ #category : #'as yet unclassified' }
GAEngine >> endIfNoImprovementFor: nbOfGenerations [
	"End if no improvement occurred within a given number of generations"
	^ self endIfNoImprovementFor: nbOfGenerations withinRangeOf: 0
]

{ #category : #'as yet unclassified' }
GAEngine >> endIfNoImprovementFor: nbOfGenerations withinRangeOf: delta [
	"End if no improvement occurred (within a delta value) within a given number of generations"
	terminationBlock := [ 
		(logs last generationNumber >= nbOfGenerations) and: [ 
			| fs |
			fs := (logs last: nbOfGenerations) collect: [ :aLog | aLog fittestIndividual fitness ].
			(fs max - fs min) <= delta
			 ] ]
]

{ #category : #'as yet unclassified' }
GAEngine >> fitnessBlock [
	"Return the fitness block used by the engine"
	^ fitnessBlock
]

{ #category : #'as yet unclassified' }
GAEngine >> fitnessBlock: aOneArgBlock [
	"The argument is evaluated on the genes of each individual.
	The block argument has to compute the fitness."
	fitnessBlock := aOneArgBlock
]

{ #category : #'as yet unclassified' }
GAEngine >> gtInspectorLogsIn: composite [
	<gtInspectorPresentationOrder: -5>
	composite list
		title: 'Logs';
		display: [ self logs ]
]

{ #category : #'as yet unclassified' }
GAEngine >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: [ self visualize ]
]

{ #category : #'as yet unclassified' }
GAEngine >> initialize [
	super initialize.
	logs := OrderedCollection new.
	random := Random seed: 42.
	self endForMaxNumberOfGeneration: 10.
	populationSize := 10.
	self maximizeComparator.
	mutationOperator := GAMutationOperation new.
	mutationOperator mutationRate: 0.01.
	mutationOperator random: random.
	
	crossoverOperator := GACrossoverOperation new.
	crossoverOperator random: random.
	
	self selection: GATournamentSelection new.

	beforeCreatingInitialIndividual := 
			[ :rand | "do nothing per default" ] 
]

{ #category : #'as yet unclassified' }
GAEngine >> initializePopulation [
	self checkForRandomNumber.
	population := OrderedCollection new.
	populationSize timesRepeat: [ 
		| ind |
		beforeCreatingInitialIndividual value: random.
		ind := GAIndividual new.
		population add:
			(ind
				random: random;
				set: numberOfGenes genesUsing: createGeneBlock) ]
]

{ #category : #'as yet unclassified' }
GAEngine >> isIndividual: anIndividual betterThan: aFittestIndividual [
	"Compare an individual against the fittest individual of the population"
	^ compareFitness value: anIndividual fitness value: aFittestIndividual fitness
]

{ #category : #'as yet unclassified' }
GAEngine >> logs [
	"Return the logs of the run"
	^ logs
]

{ #category : #'as yet unclassified' }
GAEngine >> maximizeComparator [
	"A better individual is the one with the highest fitness value"
	compareFitness := [ :f1 :f2 | f1 > f2 ]
]

{ #category : #'as yet unclassified' }
GAEngine >> microPause [
	"Useful when you wish to log in the Transcript and see progresses"
	(Delay forMilliseconds: 1) wait.
	World doOneCycleNow.
]

{ #category : #'as yet unclassified' }
GAEngine >> minimizeComparator [
	"A better individual is the one with the lowest fitness value"
	compareFitness := [ :f1 :f2 | f1 < f2 ]
]

{ #category : #'as yet unclassified' }
GAEngine >> mutate: individual [
	"Mutate the child provided as argument"
	^ mutationOperator mutate: individual
]

{ #category : #'as yet unclassified' }
GAEngine >> mutationOperator: aMutationOperator [
	mutationOperator := aMutationOperator.
	aMutationOperator random: random
]

{ #category : #'as yet unclassified' }
GAEngine >> mutationRate: aFloat [
	"Set the mutation rate used by the engine. The default value is 0.01"
	mutationOperator mutationRate: aFloat.
]

{ #category : #'as yet unclassified' }
GAEngine >> numberOfGenes: anInteger [
	"Set the number of genes each individual will have"
	numberOfGenes := anInteger
]

{ #category : #'as yet unclassified' }
GAEngine >> populationSize: anInteger [
	"Set the population size"
	populationSize := anInteger
]

{ #category : #'as yet unclassified' }
GAEngine >> produceNewPopulation [
	"This method  
		- produces a new population, set in the variable 'population'
		- select the fittest element of the population"
	selection doSelection.
	population := selection population.
]

{ #category : #'as yet unclassified' }
GAEngine >> randomNumber: maxNumber [
	"Return a number between 1 and maxNumber"
	^ random nextInt: maxNumber
]

{ #category : #'as yet unclassified' }
GAEngine >> result [
	"Return the genes of the fittest individual. This method is expected to be executed after #run has completed"
	^ self logs last fittestIndividual genes
]

{ #category : #'as yet unclassified' }
GAEngine >> run [
    "Public method -- Run the genetic algorithm"

    | t log |
    self beforeRun.
    self initializePopulation.
    selection initialPopulation: population.
    selection compareFitness: compareFitness.
    UIManager default
        informUserDuring: [ :bar | 
            | gen |
            gen := 0.
            [ self shouldTerminate ] whileFalse: [ gen := gen + 1.
                bar label: gen asString.
                self microPause.
                t := Time now asSeconds.
                self produceNewPopulation.
                    
                log := GALog new.
                log generationNumber: gen.
                log fittestIndividual: selection fittest.
                log worseFitness: ((population collect: #fitness) inject: log bestFitness into: [ :wFit :current | (compareFitness value: wFit value: current) ifTrue: [ current ] ifFalse: [ wFit ] ]).
				log averageFitness: (population collect: #fitness) average asFloat. 
                log timeToProduceGeneration: Time now asSeconds - t.
                logs add: log ] ]
]

{ #category : #'as yet unclassified' }
GAEngine >> selection [
	"Return the selection operator"
	^ selection
]

{ #category : #'as yet unclassified' }
GAEngine >> selection: aSelection [
	"Set the selection method to be used to create a new population"
	selection := aSelection.
	aSelection engine: self.
]

{ #category : #'as yet unclassified' }
GAEngine >> shouldTerminate [
	logs ifEmpty: [ ^ false ].
	^ terminationBlock value
]

{ #category : #'as yet unclassified' }
GAEngine >> timeTaken [
	"Return the time taken to compute all the generations"
	| lastLog |
	lastLog := self logs last.
	^ lastLog time - self logs first time 
]

{ #category : #'as yet unclassified' }
GAEngine >> visualize [
	"Visualize the evolution of the population"
	| g d |
	g := RTGrapher new.
	d := RTData new.
	d label: 'Best fitness'.
	d interaction popupText: [ :assoc | assoc value bestFitness ].
	d connectColor: Color blue.
	d noDot.
	d points: self logs.
	d y: #bestFitness.
	d x: #generationNumber.
	g add: d.
	
	d := RTData new.
	d label: 'Worst fitness'.
	d interaction popupText: [ :assoc | assoc value worseFitness ].
	d connectColor: Color red.
	d noDot.
	d points: self logs.
	d y: #worseFitness.
	d x: #generationNumber.
	g add: d.
	
	d := RTData new.
	d label: 'Average fitness'.
	d interaction popupText: [ :assoc | assoc value averageFitness ].
	d connectColor: Color green.
	d noDot.
	d points: self logs.
	d y: #averageFitness.
	d x: #generationNumber.
	g add: d.
	g legend addText: 'Fitness evolution'.
	g axisY title: 'Fitness'.
	g axisX noDecimal; title: 'Generation'.
	^ g
]
