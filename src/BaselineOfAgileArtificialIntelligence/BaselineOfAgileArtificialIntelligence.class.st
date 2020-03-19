Class {
	#name : #BaselineOfAgileArtificialIntelligence,
	#superclass : #BaselineOf,
	#category : #BaselineOfAgileArtificialIntelligence
}

{ #category : #baselines }
BaselineOfAgileArtificialIntelligence >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec baseline: 'Roassal2' with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
			
			spec package: 'NeuralNetwork' with: [ spec requires: 'Roassal2' ].
			spec package: 'Matrix'.
			spec package: 'NeuralNetwork-Matrix' with: [ spec requires: #('Matrix' 'NeuralNetwork') ].
			
			spec package: 'GeneticAlgorithm-Core'.
			spec package: 'GeneticAlgorithm-Tests' with: [ spec requires: 'GeneticAlgorithm-Core' ].
			spec package: 'Robot' with: [ spec requires: 'GeneticAlgorithm-Core' ].
			spec package: 'Creature' with: [ spec requires: 'GeneticAlgorithm-Core' ].
			
			spec package: 'NEAT' with: [ spec requires: 'Roassal2' ].
			spec package: 'MiniMario' with: [ spec requires: 'NEAT' ].
			
			spec group: 'Core' with: #('NeuralNetwork' 'Matrix' 'NeuralNetwork-Matrix' 'GeneticAlgorithm-Core' 'GeneticAlgorithm-Tests' 'Robot' 'Creature' 'NEAT' 'MiniMario')
		]
]
