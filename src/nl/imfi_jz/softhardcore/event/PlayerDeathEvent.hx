package nl.imfi_jz.softhardcore.event;

import nl.imfi_jz.minecraft_api.Event;
import nl.imfi_jz.softhardcore.file.Config;

class PlayerDeathEvent implements Event {
    private final config:Config;
    
    public function new(config) {
        this.config = config;
    }

	public function getName():String {
		return "PlayerDeathEvent";
	}

	public function occur(involvement:EventData) {
        final player = involvement.getPlayers()[0];
        final maxHealth = player.getCondition().getMax();
        final healthReduction = config.getHealthReductionOnDeath();
        
        #if mc_debug
        player.tell("Max health: " + maxHealth);
        player.tell("Health reduction: " + healthReduction);
        #end

        final newMaxHealth = maxHealth - healthReduction * 2;

        if(newMaxHealth > 0){
            player.getCondition().setMax(newMaxHealth);
        }
        else {
            player.getCondition().setMax(20);
            player.setGameMode("spectator");
        }
    }
}