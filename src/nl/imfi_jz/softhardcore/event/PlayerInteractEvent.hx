package nl.imfi_jz.softhardcore.event;

import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Displayable.DisplayableMessageBuilder;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.minecraft_api.GameObject.Item;
import nl.imfi_jz.softhardcore.file.Config;
import nl.imfi_jz.minecraft_api.Event;

class PlayerInteractEvent implements CancelingEvent {
    private final config:Config;
    private final displayableMessageBuilder:DisplayableMessageBuilder;

    public function new(config, messageBuilder) {
        this.config = config;
        this.displayableMessageBuilder = messageBuilder;

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
            if(canConsumeItemToIncreaseHealth(involvement.getPlayers()[0], involvement.getItems()[0])){
                return consumeItemToIncreaseHealth(involvement.getPlayers()[0], involvement.getItems()[0]);
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
        return rightClick && hand;
    }

    private function canConsumeItemToIncreaseHealth(player:Player, item:Item):Bool {
        final requiredItemName = config.getHealthIncreaseItemName();
        
        if(requiredItemName != null && item?.isA(requiredItemName)){
            Debugger.log('Correct item');
            if(player.getCondition().getMax() < config.getHealthIncreaseMax() * 2){
                Debugger.log('Max health is below config max');
                return true;
            }
            else return false;
        }
        else return false;
    }

	private function consumeItemToIncreaseHealth(player:Player, itemConsumed:Item):Bool {
        final currentMaxHealth = player.getCondition().getMax();
        final newMaxHealth = Math.min(
            currentMaxHealth + config.getHealthIncreaseAmount() * 2,
            config.getHealthIncreaseMax() * 2
        );
        Debugger.log('New max health: $newMaxHealth');

        player.getCondition().setMax(newMaxHealth);

        final maxHealthDifference = newMaxHealth - currentMaxHealth;
        final subTitleText = Std.string(maxHealthDifference / 2)
            + (maxHealthDifference == 2 ? ' heart ' : ' hearts')
            + ' restored';

        return displayableMessageBuilder.toSubTitle(subTitleText).displayToPlayer(player)
            && player.getEquipment().setQuantity(
                player.getEquipment().getPrimaryHandSlot(),
                player.getEquipment().getQuantity(player.getEquipment().getPrimaryHandSlot()) - 1
            );
	}
}