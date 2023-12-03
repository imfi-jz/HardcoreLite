package nl.imfi_jz.softhardcore.event;

import nl.imfi_jz.minecraft_api.Gate.Game;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Displayable.DisplayableMessageBuilder;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.minecraft_api.GameObject.Item;
import nl.imfi_jz.softhardcore.file.Config;
import nl.imfi_jz.minecraft_api.Event;

class PlayerInteractEvent implements CancelingEvent {
    private final config:Config;
    private final displayableMessageBuilder:DisplayableMessageBuilder;
    private final healthIncreaseItemUtil:HealthIncreaseItemUtil;
    private final game:Game;

    public function new(config, messageBuilder, healthIncreaseItemUtil, game) {
        this.config = config;
        this.displayableMessageBuilder = messageBuilder;
        this.healthIncreaseItemUtil = healthIncreaseItemUtil;
        this.game = game;

        displayableMessageBuilder
            .setFadeInTime(1)
            .setFadeOutTime(1)
            .setTimeVisible(4);
    }
    
	public function getName():String {
        return "PlayerInteractEvent";
	}

	public function occur(involvement:EventData) {
    }

	public function shouldCancel(involvement:EventData):Bool {
        #if mc_debug
        involvement.getPlayers()[0].tell('Cancelled: ' + involvement.isCancelled());
        involvement.getPlayers()[0].tell('Booleans: ' + involvement.getBooleans());
        involvement.getPlayers()[0].tell('Enum values: ' + involvement.getEnumValues());
        involvement.getPlayers()[0].tell('Strings: ' + involvement.getStrings());
        involvement.getPlayers()[0].tell('Items: ' + involvement.getItems().map(item -> item.getName()));
        #end

        if(!involvement.isCancelled() && interactionIsValid(involvement)){
            Debugger.log('Interaction valid');
            final itemUsed = involvement.getItems()[0];
            final givingPlayer = involvement.getPlayers()[0];
            final receivingPlayer = itemUsed.getDisplayName() == ''
                ? givingPlayer
                : findPlayerWithName(itemUsed.getDisplayName(), game);

            if(receivingPlayer == null){
                givingPlayer.tell('The player you are trying to revive "' + itemUsed.getDisplayName() + '" is not online');
                return true;
            }
            
            if(canConsumeItemToIncreaseHealth(receivingPlayer, itemUsed)){
                if(!receivingPlayer.matches(givingPlayer)){
                    notifyGivingPlayerTheyHealedReceivingPlayer(givingPlayer, receivingPlayer);
                }

                removeItemFromPlayer(givingPlayer);
                notifyPlayerTheyWereHealed(receivingPlayer);
                healPlayer(receivingPlayer, givingPlayer);

                return true;
            }
            else return false;
        }
        else return false;
	}

    private function interactionIsValid(involvement:EventData):Bool {
        var rightClick = false;
        var hand = false;
        for(enumValue in involvement.getEnumValues()){
            enumValue = enumValue.toUpperCase();
            if(StringTools.contains(enumValue, 'RIGHT_CLICK')){
                rightClick = true;
            }
            else if(enumValue == 'HAND'){
                hand = true;
            }
        }
        return rightClick
            && hand
            && involvement.getItems()[0] != null;
    }

    private function findPlayerWithName(playerName:String, game:Game): Player {
        for(world in game.getWorlds()) {
            for(player in world.getPlayers()) {
                if(player.getName() == playerName){
                    Debugger.log('Found player with name: $playerName');
                    return player;
                }
            }
        }
        return null;
    }

    private function canConsumeItemToIncreaseHealth(player:Null<Player>, item:Null<Item>):Bool {
        if(healthIncreaseItemUtil.isHealthIncreaseItem(item) && player != null){
            Debugger.log('Correct item');
            if(player.getCondition().getMax() < config.getHealthIncreaseMax() * 2){
                Debugger.log('Max health is below config max');
                return true;
            }
            else {
                player.tell('Your max health cannot be increased any further');
                return false;
            }
        }
        else return false;
    }

    private function healPlayer(healedPlayer:Player, healingPlayer:Player) {
        if(healedPlayer.getGameMode().toUpperCase() == 'SPECTATOR') {
            healedPlayer.teleport(healingPlayer.getCoordinates());
            healedPlayer.getCondition().setMax(config.getHealthIncreaseAmount() * 2);
            healedPlayer.setGameMode(healingPlayer.getGameMode());
            Debugger.log(healingPlayer.getName() + ' revived player: ' + healedPlayer.getName());
        }
        else {
            healedPlayer.getCondition().setMax(getMaxHealthAfterUsingItem(healedPlayer));
            Debugger.log(healingPlayer.getName() + ' healed player: ' + healedPlayer.getName());
        }
    }

    private function removeItemFromPlayer(player:Player) {
        player.getEquipment().setQuantity(
            player.getEquipment().getPrimaryHandSlot(),
            player.getEquipment().getQuantity(player.getEquipment().getPrimaryHandSlot()) - 1
        );
        Debugger.log('Removed item from ' + player.getName());
    }

    private function notifyPlayerTheyWereHealed(player:Player) {
        final currentMaxHealth = player.getCondition().getMax();
        final newMaxHealth = getMaxHealthAfterUsingItem(player);
        final maxHealthDifference = newMaxHealth - currentMaxHealth;
        
        final subTitleText = Std.string(maxHealthDifference / 2)
            + (maxHealthDifference == 2 ? ' heart ' : ' hearts')
            + ' restored';

        displayableMessageBuilder.toSubTitle(subTitleText).displayToPlayer(player);
    }

    private function getMaxHealthAfterUsingItem(player:Player): Float {
        final newMaxHealth = Math.min(
            player.getCondition().getMax() + config.getHealthIncreaseAmount() * 2,
            config.getHealthIncreaseMax() * 2
        );
        Debugger.log('New max health: $newMaxHealth');
        return newMaxHealth;
    }

    private function notifyGivingPlayerTheyHealedReceivingPlayer(givingPlayer:Player, receivingPlayer:Player) {
        if(receivingPlayer.getGameMode().toUpperCase() == 'SPECTATOR') {
            displayableMessageBuilder.toSubTitle('Revived ' + receivingPlayer.getName())
                .displayToPlayer(givingPlayer);
        }
        else displayableMessageBuilder.toSubTitle('Healed ' + receivingPlayer.getName())
            .displayToPlayer(givingPlayer);
    }
}