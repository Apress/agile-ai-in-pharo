Class {
	#name : #NEIndividual,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'connections',
		'random',
		'fitness',
		'species'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEIndividual >> addConnection: aConnection [
	"Add a connection to the individual"
	connections add: aConnection.
	self resetNetwork.
]

{ #category : #'as yet unclassified' }
NEIndividual >> addHiddenNode [
	"Add a hidden node"
	^ self addNode: (NENode new setAsHidden)
]

{ #category : #'as yet unclassified' }
NEIndividual >> addInputNode [
	"Add an input node"
	self addNode: (NENode new setAsInput; innovationNumber: 1).
]

{ #category : #'as yet unclassified' }
NEIndividual >> addNode: aNode [
	"Add a node to the individual. Note that the connections must be invalided and are therefore reset."
	self resetNetwork.
	nodes add: aNode.
	aNode id: nodes size.
	^ aNode
]

{ #category : #'as yet unclassified' }
NEIndividual >> addOutputNode [
	"Add an output node"
	self addNode: (NENode new setAsOutput; innovationNumber: 1).
]

{ #category : #'as yet unclassified' }
NEIndividual >> buildNetwork [
	"Build the neural network represented by the individual"
	self resetNetwork.
	(connections select: #isEnabled) do: [ :c | 
		(nodes at: c in) connect: (nodes at: c out) weight: c weight.
		(nodes at: c out) increaseNumberOfInputs ]
]

{ #category : #'as yet unclassified' }
NEIndividual >> computeFitness: oneArgBlock [
	"Compute the fitness of an individual"
	"If already computed, then there is nothing to do"
	fitness ifNotNil: [ ^ self ].
	fitness := oneArgBlock value: self.
]

{ #category : #'as yet unclassified' }
NEIndividual >> connections [
	"Return the list of connections"
	^ connections 
]

{ #category : #'as yet unclassified' }
NEIndividual >> connections: someConnections [
	"Set some connections. 
	 This method is used when performing the crossover."
	connections := someConnections 
]

{ #category : #'as yet unclassified' }
NEIndividual >> copy [
	"Return a copy of the individual"
	| newInd |
	newInd := NEIndividual new.
	newInd random: self random.
	newInd nodes: (self nodes collect: #copy).
	newInd connections: (self connections collect: #copy).
	^ newInd
]

{ #category : #'as yet unclassified' }
NEIndividual >> evaluate: anArray [
	"Evaluate the network using some input values. 
	 The method returns the resulting outputs of the network"
	self assert: [ anArray size = self numberOfInputs ] description: 'Wrong number of arguments'.
	
	self buildNetwork.
	
	"We provide 1 to the first node, which is considered as the bias node"
	self inputNodes with: #(1), anArray do: [ :n :aValue | n evaluate: aValue ].
	^ self outputNodes collect: [ :n | n result ] as: Array
]

{ #category : #'as yet unclassified' }
NEIndividual >> fitness [
	"Return the fitness of the individual"
	self assert: [ fitness notNil ] description: 'Need to compute fitness first'.
	^ fitness
]

{ #category : #'as yet unclassified' }
NEIndividual >> fitness: aFitnessValue [
	"Set the fitness value, useful when copying an individual"
	fitness := aFitnessValue
]

{ #category : #'as yet unclassified' }
NEIndividual >> gtInspectorViewIn: composite [
	<gtInspectorPresentationOrder: -10>
	composite roassal2
		title: 'View';
		initializeView: [ self visualize ]
]

{ #category : #'as yet unclassified' }
NEIndividual >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	connections := OrderedCollection new.
	
	"This first node is the bias node"
	self addInputNode
]

{ #category : #'as yet unclassified' }
NEIndividual >> innovationNumberSequence [
	"Return the list of innovation number"
	self connections ifEmpty: [ ^ #(0) ].
	^ self connections collect: #innovationNumber as: Array
]

{ #category : #'as yet unclassified' }
NEIndividual >> inputNodes [
	"Return the input nodes"
	^ nodes select: #isInput
]

{ #category : #'as yet unclassified' }
NEIndividual >> nodes [
	"Return the nodes contained by the individual"
	^ nodes
]

{ #category : #'as yet unclassified' }
NEIndividual >> nodes: someNodes [
	"Set the nodes"
	nodes := someNodes 
]

{ #category : #'as yet unclassified' }
NEIndividual >> numberOfConnections [
	"Return the number of connections"
	^ connections size
]

{ #category : #'as yet unclassified' }
NEIndividual >> numberOfInputs [
	"We substrate one for the bias"
	^ self inputNodes size - 1
]

{ #category : #'as yet unclassified' }
NEIndividual >> numberOfNodesWithBias [
	"Return the total number of nodes contained in the individual"
	^ self nodes size
]

{ #category : #'as yet unclassified' }
NEIndividual >> outputNodes [
	"Return the output nodes"
	^ nodes select: #isOutput
]

{ #category : #'as yet unclassified' }
NEIndividual >> predict: inputs [
	"Make a prediction. This method assumes that the number of outputs is the same as the number of different values the network can output"
	| outputs |
	outputs := self evaluate: inputs.
	"The index of a collection begins at 1 in Pharo"
	^ (outputs indexOf: (outputs max)) - 1
]

{ #category : #'as yet unclassified' }
NEIndividual >> random [
	"Return the random number used by the genetic operations"
	^ random
]

{ #category : #'as yet unclassified' }
NEIndividual >> random: aRandomNumberGenerator [
	"Set the random number used by the genetic operations"
	random := aRandomNumberGenerator
]

{ #category : #'as yet unclassified' }
NEIndividual >> resetFitness [
	"Invalidated the fitness"
	fitness := nil
]

{ #category : #'as yet unclassified' }
NEIndividual >> resetNetwork [
	"Reset the network, which invalidate the network and the fitness value"
	nodes do: #resetConnections
]

{ #category : #'as yet unclassified' }
NEIndividual >> species [
	"Return the species to which the individual belongs to"
	^ species
]

{ #category : #'as yet unclassified' }
NEIndividual >> species: aSpecies [
	species := aSpecies
]

{ #category : #'as yet unclassified' }
NEIndividual >> visualize [
	"Visualization of the associated neural network"
	| b legendBuilder |
	self buildNetwork.
	b := RTMondrian new.
	b shape label text: #id;
		color: Color gray;
		if: #isInput color: Color blue;
		if: #isOutput color: Color red;
		if: #isBias color: Color yellow.
	b nodes: self nodes.

	b shape line color: (Color gray alpha: 0.8).
	b edges connectToAll: #connectedNodes.
	b layout tree; ifNotConnectedThen: RTGridLayout new.

	"The line width reflect the weight of the connection"
	b normalizer 
		normalizeLineWidth: [ :from :to | from weightOfConnectionWith: to ] min: 0.5 max: 4.
	b build.
	
	"Render a legend on demand, accessible from the ? top left icon"
	legendBuilder := RTLegendBuilder new.
	legendBuilder onDemand.
	legendBuilder view: b view.
	legendBuilder addText: 'Individual visualization'.
	legendBuilder addColor: Color blue text: 'Input node'.
	legendBuilder addColor: Color red text: 'Output node'.
	legendBuilder addColor: Color yellow text: 'Bias node'.
	legendBuilder addColor: Color gray text: 'Hidden node'.
	legendBuilder build.
	^ b view
]
