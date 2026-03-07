import { Intent } from '../types';

export class IntentParser {
  public static parse(text: string): Intent {
    const input = text.toLowerCase();

    // 1. Clear Programmer
    if (input.includes('clear')) {
      return { intent: 'clear_programmer', params: {}, confidence: 1 };
    }

    // 2. Patch Fixture
    const patchMatch = input.match(/patch\s+(.+?)\s+.*univers\s+(\d+)\s+.*adresse\s+(\d+)/);
    if (patchMatch) {
      return {
        intent: 'patch_fixture',
        params: {
          fixtureName: patchMatch[1].trim(),
          universe: parseInt(patchMatch[2]),
          address: parseInt(patchMatch[3])
        },
        confidence: 0.9
      };
    }

    // 3. Set Dimmer
    const dimmerMatch = input.match(/(?:mets|set)\s+(.+?)\s+à\s+(\d+)/);
    if (dimmerMatch) {
      return {
        intent: 'set_dimmer',
        params: {
          target: dimmerMatch[1].trim(),
          value: parseInt(dimmerMatch[2])
        },
        confidence: 0.9
      };
    }

    // 4. Select Group
    if (input.includes('sélectionne') || input.includes('select')) {
      const groupMatch = input.match(/(?:sélectionne|select)\s+(?:les\s+)?(.+)/);
      if (groupMatch) {
        return {
          intent: 'select_group',
          params: { groupName: groupMatch[1].trim() },
          confidence: 0.8
        };
      }
    }

    // 5. Store Preset
    const storeMatch = input.match(/store\s+(?:un\s+)?preset\s+(.+)/);
    if (storeMatch) {
      return {
        intent: 'store_preset',
        params: { presetType: storeMatch[1].trim() },
        confidence: 0.8
      };
    }

    return { intent: 'unknown', params: {}, confidence: 0 };
  }
}