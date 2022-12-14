package nl.imfi_jz.softhardcore.event;

import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Displayable.DisplayableMessageBuilder;
import nl.imfi_jz.softhardcore.file.Config;
import nl.imfi_jz.minecraft_api.Event;

class PlayerRespawnEvent implements Event {
    private final config:Config;
    private final displayableMessageBuilder:DisplayableMessageBuilder;
    private final scheduler:Scheduler;

    public function new(config, messageBuilder, scheduler) {
        this.config = config;
        this.displayableMessageBuilder = messageBuilder;
        this.scheduler = scheduler;

        this.displayableMessageBuilder
            .setFadeInTime(1)
            .setFadeOutTime(2)
            .setTimeVisible(6);
    }

	public function getName():String {
		return "PlayerRespawnEvent";
	}

	public function occur(involvement:EventData) {
        final player = involvement.getPlayers()[0];
        
        if(player.getGameMode().toUpperCase() == "SPECTATOR"){
            displayableMessageBuilder.toSubTitle("You are out of hearts!").displayToPlayer(player);
        }
        else {
            final heartReductionCount = config.getHealthReductionOnDeath();
            final heartTxt = heartReductionCount == 1
                ? "heart"
                : "hearts";
            displayableMessageBuilder.toSubTitle(
                "You lost " + heartReductionCount + " " + heartTxt
            ).displayToPlayer(player);
        }
    }
}