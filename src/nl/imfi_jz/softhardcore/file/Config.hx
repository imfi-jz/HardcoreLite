package nl.imfi_jz.softhardcore.file;

import haxe.ds.Vector;
import nl.imfi_jz.minecraft_api.KeyValueFile;

class Config {
    private static inline final HEALTH_REDUCTION_ON_DEATH_KEY = "Hearts lost upon death";
    private static inline final HEALTH_INCREASE_ITEM_NAME_KEY = "Health increase item type";
    private static inline final HEALTH_INCREASE_AMOUNT_KEY = "Hearts restored upon using item";
    private static inline final HEALTH_INCREASE_MAX_KEY = "Maximum hearts that can be restored";

    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY = "Health increase item recipe items";
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Top left"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Top middle"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Top right"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Middle left"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Middle middle"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Middle right"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Bottom left"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Bottom middle"];
    private static final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY = [HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_SECTION_KEY, "Bottom right"];

    private final file:NestableKeyValueFile<Any>;

    public function new(file) {
        this.file = file;
        final healthIncreaseItemName = 'Totem of Undying';

        if(file.getValue(HEALTH_REDUCTION_ON_DEATH_KEY) == null){
            setHealthReductionOnDeath(1);
        }

        if(file.getValue(HEALTH_INCREASE_ITEM_NAME_KEY) == null){
            setHealthIncreaseItemName(healthIncreaseItemName);
        }

        if(file.getValue(HEALTH_INCREASE_AMOUNT_KEY) == null){
            setHealthIncreaseAmount(5);
        }

        if(file.getValue(HEALTH_INCREASE_MAX_KEY) == null){
            setHealthIncreaseMax(10);
        }

        var setDefaultRecipe = true;
        for(recipeItemName in getHealthIncreaseItemCraftingRecipe()){
            if(recipeItemName != null){
                setDefaultRecipe = false;
                break;
            }
        }
        if(setDefaultRecipe){
            final defaultRecipe = new Vector<String>(9);
            final goldIngot = 'Gold Nugget';
            defaultRecipe[0] = goldIngot;
            defaultRecipe[1] = goldIngot;
            defaultRecipe[2] = goldIngot;
            defaultRecipe[3] = goldIngot;
            defaultRecipe[4] = healthIncreaseItemName;
            defaultRecipe[5] = goldIngot;
            defaultRecipe[6] = goldIngot;
            defaultRecipe[7] = goldIngot;
            defaultRecipe[8] = goldIngot;
            setHealthIncreaseItemCraftingRecipe(defaultRecipe);
        }
    }

    public function getHealthReductionOnDeath():Float {
        return Std.parseFloat(file.getValue(HEALTH_REDUCTION_ON_DEATH_KEY));
    }
    public function setHealthReductionOnDeath(value:Float) {
        file.setValue(HEALTH_REDUCTION_ON_DEATH_KEY, value);
    }

    public function getHealthIncreaseItemName():Null<String> {
        final val = file.getValue(HEALTH_INCREASE_ITEM_NAME_KEY);
        final itemName = val is String
            ? cast(val, String).toUpperCase()
            : null;

        if(itemName == null
            || itemName == ''
            || itemName == 'NULL'
            || itemName == 'NONE'
        ){
            return null;
        }

        return itemName;
    }
    private function setHealthIncreaseItemName(value:String) {
        file.setValue(HEALTH_INCREASE_ITEM_NAME_KEY, value);
    }

    public function getHealthIncreaseAmount():Float {
        return Std.parseFloat(file.getValue(HEALTH_INCREASE_AMOUNT_KEY));
    }
    private function setHealthIncreaseAmount(value:Float) {
        file.setValue(HEALTH_INCREASE_AMOUNT_KEY, value);
    }

    public function getHealthIncreaseMax():Float {
        return Std.parseFloat(file.getValue(HEALTH_INCREASE_MAX_KEY));
    }
    private function setHealthIncreaseMax(value:Float) {
        file.setValue(HEALTH_INCREASE_MAX_KEY, value);
    }

    public function getHealthIncreaseItemCraftingRecipe():Vector<String> {
        final recipe = new Vector<String>(9);

        recipe[0] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY);
        recipe[1] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY);
        recipe[2] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY);
        recipe[3] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY);
        recipe[4] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY);
        recipe[5] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY);
        recipe[6] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY);
        recipe[7] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY);
        recipe[8] = file.getValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY);

        return recipe;
    }
    private function setHealthIncreaseItemCraftingRecipe(recipe:Vector<String>) {
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY, recipe[0]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY, recipe[1]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY, recipe[2]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY, recipe[3]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY, recipe[4]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY, recipe[5]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY, recipe[6]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY, recipe[7]);
        file.setValueByNestedKey(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY, recipe[8]);
    }
}