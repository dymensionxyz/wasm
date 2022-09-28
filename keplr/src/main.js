import {SigningCosmosClient} from '@cosmjs/launchpad'

const addNetwork = async (chainId, chainName, rpc, rest, coinDenom, coinMinimalDenom, bech32Prefix) => {
    if (!window.getOfflineSigner || !window.keplr) {
        alert("Please install keplr extension");
    } else {
        if (window.keplr.experimentalSuggestChain) {
            try {
                await window.keplr.experimentalSuggestChain({
                    chainId,
                    chainName,
                    rpc,
                    rest,
                    stakeCurrency: {
                        coinDenom,
                        coinMinimalDenom,
                        coinDecimals: 6,
                    },
                    bip44: {
                        coinType: 118,
                    },
                    bech32Config: {
                        bech32PrefixAccAddr: bech32Prefix,
                        bech32PrefixAccPub: bech32Prefix + "pub",
                        bech32PrefixValAddr: bech32Prefix + "valoper",
                        bech32PrefixValPub: bech32Prefix + "valoperpub",
                        bech32PrefixConsAddr: bech32Prefix + "valcons",
                        bech32PrefixConsPub: bech32Prefix + "valconspub"
                    },
                    currencies: [{
                        coinDenom,
                        coinMinimalDenom,
                        coinDecimals: 6,
                    }],
                    feeCurrencies: [{
                        coinDenom,
                        coinMinimalDenom,
                        coinDecimals: 6,
                    }],
                    coinType: 118,
                    gasPriceStep: {
                        low: 0.01,
                        average: 0.025,
                        high: 0.04
                    }
                });
            } catch {
                alert("Failed to suggest the chain");
            }
        } else {
            alert("Please use the recent version of keplr extension");
        }
    }

    await window.keplr.enable(chainId);

    const offlineSigner = window.getOfflineSigner(chainId);
    const accounts = await offlineSigner.getAccounts();
    new SigningCosmosClient(rpc, accounts[0].address, offlineSigner);
};

document.addNetworkForm.onsubmit = () => {
    const chainId = document.addNetworkForm.chainId.value;
    const chainName = document.addNetworkForm.chainName.value;
    const rpcEndpoint = document.addNetworkForm.rpcEndpoint.value;
    const restEndpoint = document.addNetworkForm.restEndpoint.value;
    const coinDenom = document.addNetworkForm.coinDenom.value;
    const coinMinimalDenom = document.addNetworkForm.coinMinimalDenom.value;
    const bech32Prefix = document.addNetworkForm.bech32Prefix.value;

    return addNetwork(chainId, chainName, rpcEndpoint, restEndpoint, coinDenom, coinMinimalDenom, bech32Prefix);
};
