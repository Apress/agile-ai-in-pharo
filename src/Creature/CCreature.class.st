Class {
	#name : #CCreature,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'muscles',
		'random',
		'muscleGenerator',
		'color'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CCreature >> addMuscleFrom: aNode to: anotherNode [
	"Generate and add a muscle between two nodes"
	muscles add: (muscleGenerator createMuscleFrom: aNode to: anotherNode)
]

{ #category : #'as yet unclassified' }
CCreature >> addMuscleFromIndex: n1 toIndex: n2 [

	muscles add: (muscleGenerator createMuscleFrom: (self nodes at: n1) to: (self nodes at: n2))
]

{ #category : #'as yet unclassified' }
CCreature >> beat [
	"Execute a unit of behavior"
	nodes do: #beat.
	muscles do: #beat.
	self reachStable
]

{ #category : #'as yet unclassified' }
CCreature >> checkForCollision: platforms [
	"Check if a creature is on a platform. 
	 If this is the case, then the variable isOnPlatform of each node
	 is set to true"
	nodes do: [ :n | n checkForCollision: platforms ].
	self simulateNoise.
]

{ #category : #'as yet unclassified' }
CCreature >> color: aColor [
	"Set the color of the creature"
	color := aColor
]

{ #category : #'as yet unclassified' }
CCreature >> configureBall: numberOfNodes [	
	"Produce a ball-like creature"
	| existingMuscles |
	muscleGenerator := CMuscleGenerator new
		minStrength: 0.01;
		deltaStrength: 0.5;
		minLength: 10;
		deltaLength: 80;
		deltaTime: 200;
		minTime: 20.

	"Add some nodes"
	self configureNodes: numberOfNodes.

	"Connect each node with all the other nodes"
	existingMuscles := OrderedCollection new.
	nodes do: [ :n1 |
		(nodes copyWithout: n1) do: [ :n2 |
			(existingMuscles includes: n1 -> n2) ifFalse: [ 
				self addMuscleFrom: n1 to: n2. 
				existingMuscles add: n1 -> n2; add: n2 -> n1 ] ] ].

	"Create the visual elements"
	self createElements.
	self randomlyLocateNodes
]

{ #category : #'as yet unclassified' }
CCreature >> configureNbNodes: nbNodes nbMuscles: nbMuscle [
	"Configure a creature with a given number of nodes and muscles."
	| n1 n2 tryNewNode1 tryNewNode2 |
	self configureNodes: nbNodes.
	nbMuscle timesRepeat: [ 
			n1 := nodes atRandom: random.
			n2 := n1.
			tryNewNode1 := 0.
			tryNewNode2 := 0.
			[ tryNewNode1 < 10
				and: [ n2 == n1 or: [ muscles anySatisfy: [ :mm | mm usesNodes: { n1 . n2 } ] ] ] ]
				whileTrue: [ [ tryNewNode2 < 10
						and: [ n2 == n1
								or: [ muscles anySatisfy: [ :mm |  mm usesNodes: { n1 . n2 } ] ] ] ]
						whileTrue: [ tryNewNode2 := tryNewNode2 + 1.
							n2 := nodes atRandom: random ].
					tryNewNode2 = 10
						ifTrue: [ tryNewNode1 := tryNewNode1 + 1.
							tryNewNode2 := 0.
							n1 := nodes atRandom: random ] ].
			self addMuscleFrom: n1 to: n2 ].
		
	self createElements.
	self randomlyLocateNodes
]

{ #category : #'as yet unclassified' }
CCreature >> configureNodes: nbNodes [
	"Add a number of nodes in our creature"
	nbNodes timesRepeat: [ nodes add: CNode new createElement ]
]

{ #category : #'as yet unclassified' }
CCreature >> configureWorm: length [
	"Create a work with the specified length"
	| lastTwoNodes n1 n2 index |
	"HEAD"
	nodes add: CNode new.
	nodes add: CNode new.
	lastTwoNodes := nodes last: 2.
	self addMuscleFrom: lastTwoNodes first to: lastTwoNodes second.
	
	length timesRepeat: [
		n1 := CNode new.
		n2 := CNode new.
		nodes add: n1.
		nodes add: n2.
		self addMuscleFrom: lastTwoNodes first to: n1.
		self addMuscleFrom: lastTwoNodes second to: n1.
		self addMuscleFrom: lastTwoNodes first to: n2.
		self addMuscleFrom: lastTwoNodes second to: n2.
		self addMuscleFrom: n1 to: n2.
		lastTwoNodes := { n1 . n2 } ].

	"We create the elements"
	self createElements.

	"Position the nodes to give the shape of a worm"
	index := 0.
	nodes pairsDo: [ :aNode :aSecondNode | 
		aNode translateBy: (index * 10) @ 0. 
		aSecondNode translateBy: (index * 10) @ 10.
		index := index + 1 ]
]

{ #category : #'as yet unclassified' }
CCreature >> createElements [
	"Force the creation of the all graphical elements for nodes and muscles"
	nodes do: #createElement.
	muscles do: [ :m | m color: color ].
	muscles do: #createElement.
]

{ #category : #'as yet unclassified' }
CCreature >> initialize [
	super initialize.
	nodes := OrderedCollection new.
	muscles := OrderedCollection new.
	random := Random seed: 42.
	muscleGenerator := CMuscleGenerator new.
	color := Color red.
]

{ #category : #'as yet unclassified' }
CCreature >> materialize: anArrayOfValues [
	"Materialize a array of numbers into a creature"
	| valuesPerMuscles |
	valuesPerMuscles := 
		anArrayOfValues groupsOf: 5 atATimeCollect: [ :v | v ].
	muscles with: valuesPerMuscles do: [ :m :values | 
		muscleGenerator materialize: values inMuscle: m ]
]

{ #category : #'as yet unclassified' }
CCreature >> muscles [
	"The muscles composing the creature"
	^ muscles 
]

{ #category : #'as yet unclassified' }
CCreature >> nodes [
	"The nodes composing the creature"
	^ nodes
	
]

{ #category : #'as yet unclassified' }
CCreature >> numberOfMuscles [
	"Return the number of muscles defining the creature"
	^ muscles size
]

{ #category : #'as yet unclassified' }
CCreature >> position [
	"Return the position of the creature, as the average position of the nodes"
	^ (self nodes collect: #position) sum / self nodes size
]

{ #category : #'as yet unclassified' }
CCreature >> randomlyLocateNodes [
	"Assign each node to a random position"
	nodes
		do: [ :n | n translateBy: (random nextInt: 50) @ (random nextInt: 50) ]
]

{ #category : #'as yet unclassified' }
CCreature >> reachStable [
	"Apply the physical law on a creature"
	| n1 n2 delta actualLength unit force |
	nodes do: #resetForce.
	muscles do: [ :m |
		n1 := m node1.
		n2 := m node2.
		delta := n2 position - n1 position.
		actualLength := delta r max: 1.
		unit := delta / actualLength.
		force := 0.1 * m strength * (actualLength - m length) * unit.
		n1 addForce: force.
		n2 addForce: force negated ].
]

{ #category : #'as yet unclassified' }
CCreature >> resetPosition [
	"Locate the creature at the initial position"
	self translateTo: 0 @ 0
]

{ #category : #'as yet unclassified' }
CCreature >> serialize [
	"Serialize the creature into an array of numbers"
	^ (muscles
		flatCollect: [ :m | 
			muscleGenerator serializeMuscle: m ]) asArray
]

{ #category : #'as yet unclassified' }
CCreature >> simulateNoise [
	"Produce noise in our simulation"
	| direction |
	direction := ((random nextInt: 3) - 2) @ ((random nextInt: 3) - 2). 
	(nodes atRandom: random) translateBy: direction
]

{ #category : #'as yet unclassified' }
CCreature >> translateTo: aPoint [
	"Translate a creature to a specified position"
	| averageCenter delta |
	averageCenter := self position.
	delta := aPoint - averageCenter.
	self nodes do: [ :n | n translateBy: delta ]
]
