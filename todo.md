# TODO - Configuration Solaar et Chrome Sandbox

## Problème Solaar
Solaar ne peut pas lire les uinputs - besoin de permissions correctes et de configurer les règles

## Problème Chrome Sandbox
AppArmor empêche le sandbox de Chrome de fonctionner correctement

## Tâches

### 1. Ajouter utilisateur au groupe `input`
- [ ] Modifier la configuration NixOS pour ajouter l'utilisateur au groupe `input`
- [ ] Location: Probablement dans `hosts/` ou `flake.nix`
- [ ] Appliquer la configuration (nixos-rebuild ou home-manager switch)

### 2. Configurer les règles udev pour Solaar
- [ ] Vérifier/ajouter les règles udev pour Solaar (si nécessaire)
- [ ] Location: `/etc/udev/rules.d/` ou via NixOS services.udev.rules

### 3. Synchroniser les règles Solaar depuis Ubuntu
- [ ] Récupérer les rules de `~/.config/solaar/rules.yaml` depuis le PC Ubuntu
- [ ] Fusionner/ajouter les rules au fichier existant: `/Users/ruets/.config/home-manager/home/desktop/solaar/rules.yaml`
- [ ] Rules actuelles:
  - MouseGesture Right → Workspace -1
  - MouseGesture Left → Workspace +1
  - MouseGesture Up → hyprexpo on
  - MouseGesture Down → hyprexpo off

### 4. Fixer le Chrome Sandbox (AppArmor)
- [ ] Exécuter la commande:
  ```bash
  echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee -a /etc/sysctl.d/99-apparmor.conf
  ```
- [ ] Appliquer les paramètres:
  ```bash
  sudo sysctl -p
  ```
- [ ] Redémarrer le système ou redémarrer Chrome pour que les modifications prennent effet

### 5. Tester
- [ ] Redémarrer Solaar ou redéployer la configuration
- [ ] Vérifier que Solaar peut lire les uinputs
- [ ] Vérifier que les gestes souris fonctionnent
- [ ] Tester Chrome/Chromium pour vérifier que le sandbox fonctionne

## Notes
- Cette config est basée sur home-manager
- Besoin de l'accès à la config système NixOS pour les permissions groupe
- En attente des rules Solaar depuis Ubuntu pour la fusion
- Le fix AppArmor modifie les paramètres du noyau et nécessite un reboot pour être complètement effectif

## Ressources
- Fichier de règles Solaar: `home/desktop/solaar/rules.yaml`
- Fichier de configuration desktop: `home/desktop/desktop.nix`
- Config NixOS système: À localiser (probablement dans `hosts/`)
