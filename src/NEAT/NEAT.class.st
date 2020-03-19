Class {
	#name : #NEAT,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'populationSize',
		'population',
		'numberOfInputs',
		'numberOfOutputs',
		'logs',
		'fitness',
		'random',
		'speciation',
		'numberOfGenerations',
		'shouldUseElitism'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEAT >> buildInitialPopulation [
	"Randomly build the initial population"
	population := OrderedCollection new.
	populationSize timesRepeat: [ 
		| i |
		i := NEIndividual new.
		i random: random.
		numberOfInputs timesRepeat: [ i addInputNode ].
		numberOfOutputs timesRepeat: [ i addOutputNode ].
		population add: i ]
]

{ #category : #'as yet unclassified' }
NEAT >> computeFitnesses [
	"Compute the fitness value for each individual"
	population do: [ :i | i computeFitness: fitness ]
]

{ #category : #'as yet unclassified' }
NEAT >> crossoverBetween: ind1 and: ind2 [
	"Perform a crossover between two individuals
	 The method returns a new individual"
	^ ind1 fitness > ind2 fitness
		ifTrue: [ NECrossoverOperation new performOn: ind1 and: ind2 ]
		ifFalse: [ NECrossoverOperation new performOn: ind2 and: ind1 ]
]

{ #category : #'as yet unclassified' }
NEAT >> crossoverRate [
	"Return the crossover rate"
	| t |
	t := configuration detect: [ :assoc | assoc key isKindOf: NECrossoverOperation ] ifNone: [ ^ 0 ].
	^ t value
]

{ #category : #'as yet unclassified' }
NEAT >> currentGeneration [
	"Return the current generation"
	^ logs size	
]

{ #category : #'as yet unclassified' }
NEAT >> defaultConfiguration [
	"Make the algorithm uses a default configuration"
	self resetConfiguration.
	self for: NEConnectionWeightMutationOperation prob: 0.2.
	self for: NEAddConnectionMutationOperation prob: 0.2.
	self for: NEAddNodeMutationOperation prob: 0.01.
	self for: NECrossoverOperation prob: 0.2
]

{ #category : #'as yet unclassified' }
NEAT >> doLog [
	"Create a log object that summarize the actual generation"
	| log |
	log := NELog new.
	log generation: logs size.
	log speciation: speciation.
	log minFitness: (population collect: #fitness) min.
	log maxFitness: (population collect: #fitness) max.
	log averageFitness: ((population collect: #fitness) average asFloat round: 3).
	log bestIndividual: self result.
	logs add: log.
]

{ #category : #'as yet unclassified' }
NEAT >> doMutate: individual [
	"Perform a mutation on the individual.
	 You provide a copy of an individual as argument"
	configuration
		do: [ :cAssoc | 
			(cAssoc key isKindOf: NEAbstractMutationOperation) ifTrue: [
				random next <= cAssoc value
					ifTrue: [ cAssoc key random: random; performOn: individual ] ] ]
]

{ #category : #'as yet unclassified' }
NEAT >> doNotUseElitism [
	"Do not use elitism when generating a new population"
	shouldUseElitism := false
]

{ #category : #'as yet unclassified' }
NEAT >> doSpeciation [
	"Perform the speciation algorithm"
	speciation := NESpeciation new.
	speciation process: population.
]

{ #category : #'as yet unclassified' }
NEAT >> doUseElitism [
	"Use elitism when generating a new population"
	shouldUseElitism := true
]

{ #category : #'as yet unclassified' }
NEAT >> fitness: aOneArgumentBlock [
	"Set a one-argument block as the fitness function.
	 The block must return a numerical value, higher the value, better the individual"
	fitness := aOneArgumentBlock
]

{ #category : #'as yet unclassified' }
NEAT >> for: anOperationClass prob: prob [
	"Set the probability to apply a genetic operation"

	"Check if we have an existing configuration for the operation"
	configuration do: [ :assoc | (assoc key isKindOf: anOperationClass) 
									ifTrue: [ assoc value: prob. ^ self ] ].
	"If no, then we simply add it"
	configuration add: anOperationClass new -> prob
]

{ #category : #'as yet unclassified' }
NEAT >> gtInspectorNumberOfSpeciesIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: '#Species';
		initializeView: [ self visualizeNumberOfSpecies ]
]

{ #category : #'as yet unclassified' }
NEAT >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'Fitness';
		initializeView: [ self visualizeFitness ]
]

{ #category : #'as yet unclassified' }
NEAT >> initialize [
	super initialize.
	self defaultConfiguration.

	"We have two inputs and one bias per default"
	numberOfInputs := 2.
	numberOfOutputs := 1.
	
	populationSize := 150.
	random := Random seed: 42.
	
	logs := OrderedCollection new.
	numberOfGenerations := 10.
	
	self doUseElitism
]

{ #category : #'as yet unclassified' }
NEAT >> numberOfGenerations: anInteger [
	"Set the maximum number of generations to run before stopping the algorithm"
	numberOfGenerations := anInteger
]

{ #category : #'as yet unclassified' }
NEAT >> numberOfInputs: anInteger [
	"Set the number of inputs each individual has"
	numberOfInputs := anInteger
]

{ #category : #'as yet unclassified' }
NEAT >> numberOfOutputs: anInteger [
	"Set the number of outputs each individual has"
	numberOfOutputs := anInteger
]

{ #category : #'as yet unclassified' }
NEAT >> populationSize: anInteger [
	"Set the population size"
	populationSize := anInteger
]

{ #category : #'as yet unclassified' }
NEAT >> releaseHistory [
	"Release the memory kept in the historical logs"
	logs allButLast do: #release
]

{ #category : #'as yet unclassified' }
NEAT >> resetConfiguration [
	"Reset the configuration of the algorithm"
	configuration := OrderedCollection new
]

{ #category : #'as yet unclassified' }
NEAT >> result [
	"Return the result of the algorithm, i.e., the fittest neural network"
	| winner |
	winner := population first.
	population do: [ :i | winner fitness < i fitness ifTrue: [ winner := i ] ].
	^ winner
]

{ #category : #'as yet unclassified' }
NEAT >> run [
	"Run the algorithm"
	self buildInitialPopulation.
	self doSpeciation.
	self computeFitnesses.
	self doLog.
	self runFor: numberOfGenerations
]

{ #category : #'as yet unclassified' }
NEAT >> runFor: nbOfGenerations [
	"Run the algorithm for a given number of generation"
	'Running the NEAT algorithm'
	displayProgressFrom: 1 to: nbOfGenerations
	during: [:bar |
		1 to: nbOfGenerations do: [:x | 
			bar value: x. 
			self runOneGeneration. ] ].
]

{ #category : #'as yet unclassified' }
NEAT >> runOneGeneration [
	"Run the evolution algorithm for one generation"
	| newPopulation ind1 ind2 newInd numberOfIndividualToCreate |
	"Create the species"
	self doSpeciation.

	"We have an empty new population"
	newPopulation := OrderedCollection new.

	"The number of individual to create is either populationSize, or populationSize - 1"
	numberOfIndividualToCreate := 
		(shouldUseElitism and: [ self currentGeneration > 1 ]) 
							ifTrue: [ 
								| eli best |
								best := self result.
								eli := best copy.
								eli fitness: best fitness.
								newPopulation add: eli. 
								populationSize - 1 ] 
							ifFalse: [ populationSize ].

	"The new population is built"
	numberOfIndividualToCreate
		timesRepeat: [ 
			"Should we do a crossover or not?"
			random next <= self crossoverRate
				ifTrue: [
					"If yes, two picked elements are combined"
					ind1 := self selectIndividual.
					ind2 := self selectIndividual: ind1 species individuals.
					newInd := self crossoverBetween: ind1 and: ind2 ]
				ifFalse: [
					"If no, then we simply copy a selected individual"
					newInd := self selectIndividual copy ].
			
			"We perform the mutation on the new individual"
			self doMutate: newInd.

			"Add it to the population"
			newPopulation add: newInd.

			"Compute its fitness value"
			newInd computeFitness: fitness ].

	"The old population is replaced by the new population"
	population := newPopulation.
	self doLog
]

{ #category : #'as yet unclassified' }
NEAT >> selectIndividual [
	"Select an individual from the population using the tournament selection algorithm"
	^ self selectIndividual: population
]

{ #category : #'as yet unclassified' }
NEAT >> selectIndividual: someIndividuals [
	"Use the tournament selection algorithm to pick the best individual"
	| i k winner |
	winner := someIndividuals atRandom: random.

	"We already have picked winner, we need 4 more individuals"
	k := 4.
	k timesRepeat: [ 
		i := winner species individuals atRandom: random.
		winner fitness < i fitness ifTrue: [ winner := i ] ].

	"The winner of the tournament is returned"
	^ winner
]

{ #category : #'as yet unclassified' }
NEAT >> visualizeFitness [
	"Visualizing the max, min, and average fitness for each generation"
	| g d |
	g := RTGrapher new.
	
	"Min fitness"
	d := RTData new.
	d label: 'Minimum fitness'.
	d noDot; connectColor: Color red.
	d points: logs.
	d y: #minFitness.
	g add: d.
	
	"Max fitness"
	d := RTData new.
	d label: 'Maximum fitness'.
	d noDot; connectColor: Color blue.
	d points: logs.
	d y: #maxFitness.
	g add: d.
	
	"Average fitness"
	d := RTData new.
	d label: 'Average fitness'.
	d noDot; connectColor: Color green.
	d points: logs.
	d y: #averageFitness.
	g add: d.
	
	g axisX noDecimal; title: 'Generation'.
	g axisY title: 'Fitness'.
	g legend addText: 'Fitness evolution'.
	^ g
]

{ #category : #'as yet unclassified' }
NEAT >> visualizeNumberOfSpecies [
	"Visualize the evolution of the number of species"
	| g d |
	g := RTGrapher new.
	d := RTData new.
	d points: logs.
	d y: #numberOfSpecies.
	g add: d.
	g axisX title: 'Generation'; noDecimal.
	g axisY title: '# species'.
	^ g
]
