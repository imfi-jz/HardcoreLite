package nl.imfi_jz.softhardcore;

import nl.imfi_jz.softhardcore.file.Config;
import nl.imfi_jz.minecraft_api.GameObjectFactory.ConstructingItemFactory;
import nl.imfi_jz.minecraft_api.GameObject.Item;

class HealthIncreaseItemUtil {
    private final identifyingLore:String;
    private final itemFactory:ConstructingItemFactory;
    private final config:Config;

    public function new(pluginName:String, itemFactory, config) {
        identifyingLore = pluginName + " Health Increase Item";
        this.itemFactory = itemFactory;
        this.config = config;
    }

    public function isHealthIncreaseItem(item:Null<Item>):Bool {
        return item?.getCaption().contains(identifyingLore);
    }

    public function createHealthIncreaseItem():Null<Item> {
        final itemName = config.getHealthIncreaseItemName();
        
        if(itemName == null){
            return null;
        }
        else {
            final item = itemFactory.createGameObject(itemName);
            item.setCaption([identifyingLore]);

            return item;
        }
    }
}