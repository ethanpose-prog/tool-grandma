import { Intent } from '../types';

export class Translator {
  public static toMA3(intent: Intent): string {
    const p = intent.params;

    switch (intent.intent) {
      case 'clear_programmer':
        return "ClearAll";

      case 'select_group':
        return `Group "${p.groupName}"`;

      case 'set_dimmer':
        return `Group "${p.target}" At ${p.value}`;

      case 'patch_fixture':
        return `Set Fixture "${p.fixtureName}" "Address" ${p.universe}.${p.address}`;

      case 'store_preset':
        return `Store Preset "${p.presetType}".999`;

      default:
        throw new Error("Traduction non implémentée pour cette intention.");
    }
  }
}