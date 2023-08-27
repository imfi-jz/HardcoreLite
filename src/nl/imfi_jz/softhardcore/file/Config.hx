package nl.imfi_jz.softhardcore.file;

import nl.imfi_jz.minecraft_api.KeyValueFile;

class Config {
    private static inline final HEALTH_REDUCTION_ON_DEATH_KEY = "Hearts lost upon death";
    private static inline final HEALTH_INCREASE_ITEM_NAME_KEY = "Item used to increase health";
    private static inline final HEALTH_INCREASE_AMOUNT_KEY = "Hearts restored upon using item";
    private static inline final HEALTH_INCREASE_MAX_KEY = "Maximum hearts that can be restored";

    private final iniFile:KeyValueFile<String>;

    public function new(iniFile) {
        this.iniFile = iniFile;

        if(iniFile.getValue(HEALTH_REDUCTION_ON_DEATH_KEY) == null){
            setHealthReductionOnDeath(1);
        }

        if(iniFile.getValue(HEALTH_INCREASE_ITEM_NAME_KEY) == null){
            setHealthIncreaseItemName('Totem of Undying');
        }

        if(iniFile.getValue(HEALTH_INCREASE_AMOUNT_KEY) == null){
            setHealthIncreaseAmount(5);
        }

        if(iniFile.getValue(HEALTH_INCREASE_MAX_KEY) == null){
            setHealthIncreaseMax(10);
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
}