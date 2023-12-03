package nl.imfi_jz.softhardcore.file;

import haxe.ds.Vector;
import nl.imfi_jz.minecraft_api.KeyValueFile;

class Config {
    private static inline final HEALTH_REDUCTION_ON_DEATH_KEY = "Hearts lost upon death";
    private static inline final HEALTH_INCREASE_ITEM_NAME_KEY = "Health increase item type";
    private static inline final HEALTH_INCREASE_AMOUNT_KEY = "Hearts restored upon using item";
    private static inline final HEALTH_INCREASE_MAX_KEY = "Maximum hearts that can be restored";

    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY = "Health increase item recipe item top left";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY = "Health increase item recipe item top middle";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY = "Health increase item recipe item top right";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY = "Health increase item recipe item middle left";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY = "Health increase item recipe item middle middle";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY = "Health increase item recipe item middle right";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY = "Health increase item recipe item bottom left";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY = "Health increase item recipe item bottom middle";
    private static inline final HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY = "Health increase item recipe item bottom right";

    private final iniFile:KeyValueFile<String>;

    public function new(iniFile) {
        this.iniFile = iniFile;
        final healthIncreaseItemName = 'Totem of Undying';

        if(iniFile.getValue(HEALTH_REDUCTION_ON_DEATH_KEY) == null){
            setHealthReductionOnDeath(1);
        }

        if(iniFile.getValue(HEALTH_INCREASE_ITEM_NAME_KEY) == null){
            setHealthIncreaseItemName(healthIncreaseItemName);
        }

        if(iniFile.getValue(HEALTH_INCREASE_AMOUNT_KEY) == null){
            setHealthIncreaseAmount(5);
        }

        if(iniFile.getValue(HEALTH_INCREASE_MAX_KEY) == null){
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
        return Std.parseFloat(iniFile.getValue(HEALTH_REDUCTION_ON_DEATH_KEY));
    }
    public function setHealthReductionOnDeath(value:Float) {
        iniFile.setValue(HEALTH_REDUCTION_ON_DEATH_KEY, Std.string(value));
    }

    public function getHealthIncreaseItemName():Null<String> {
        final itemName = iniFile.getValue(HEALTH_INCREASE_ITEM_NAME_KEY)?.toUpperCase();

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
        iniFile.setValue(HEALTH_INCREASE_ITEM_NAME_KEY, value);
    }

    public function getHealthIncreaseAmount():Float {
        return Std.parseFloat(iniFile.getValue(HEALTH_INCREASE_AMOUNT_KEY));
    }
    private function setHealthIncreaseAmount(value:Float) {
        iniFile.setValue(HEALTH_INCREASE_AMOUNT_KEY, Std.string(value));
    }

    public function getHealthIncreaseMax():Float {
        return Std.parseFloat(iniFile.getValue(HEALTH_INCREASE_MAX_KEY));
    }
    private function setHealthIncreaseMax(value:Float) {
        iniFile.setValue(HEALTH_INCREASE_MAX_KEY, Std.string(value));
    }

    public function getHealthIncreaseItemCraftingRecipe():Vector<String> {
        final recipe = new Vector<String>(9);

        recipe[0] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY);
        recipe[1] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY);
        recipe[2] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY);
        recipe[3] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY);
        recipe[4] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY);
        recipe[5] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY);
        recipe[6] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY);
        recipe[7] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY);
        recipe[8] = iniFile.getValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY);

        return recipe;
    }
    private function setHealthIncreaseItemCraftingRecipe(recipe:Vector<String>) {
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_LEFT_KEY, recipe[0]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_MID_KEY, recipe[1]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_TOP_RIGHT_KEY, recipe[2]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_LEFT_KEY, recipe[3]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_MID_KEY, recipe[4]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_MID_RIGHT_KEY, recipe[5]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_LEFT_KEY, recipe[6]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_MID_KEY, recipe[7]);
        iniFile.setValue(HEALTH_INCREASE_ITEM_CRAFTING_RECIPE_BOT_RIGHT_KEY, recipe[8]);
    }
}