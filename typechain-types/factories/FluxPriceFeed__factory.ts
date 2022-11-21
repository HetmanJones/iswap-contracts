/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../common";
import type { FluxPriceFeed, FluxPriceFeedInterface } from "../FluxPriceFeed";

const _abi = [
  {
    inputs: [
      {
        components: [
          {
            internalType: "address",
            name: "asset",
            type: "address",
          },
          {
            internalType: "address",
            name: "source",
            type: "address",
          },
        ],
        internalType: "struct FluxPriceFeed.Config[]",
        name: "_config",
        type: "tuple[]",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "asset",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "source",
        type: "address",
      },
    ],
    name: "AssetPriceFeedSourceUpdated",
    type: "event",
  },
  {
    inputs: [],
    name: "TARGET_DIGITS",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_asset",
        type: "address",
      },
    ],
    name: "getAssetPrice",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x60806040523480156200001157600080fd5b506040516200103b3803806200103b8339818101604052810190620000379190620004bd565b60008151905060005b81811015620002685760008382815181106200006157620000606200050e565b5b602002602001015160000151905060008483815181106200008757620000866200050e565b5b6020026020010151602001519050600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff160362000107576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401620000fe906200059e565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff160362000179576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401620001709062000610565b60405180910390fd5b806000808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167f2efc45f9add60d3f347244a1bcc385d7e17c53b3cbd3643e2851a571bc56566660405160405180910390a3505080806200025f906200066b565b91505062000040565b505050620006b8565b6000604051905090565b600080fd5b600080fd5b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b620002d5826200028a565b810181811067ffffffffffffffff82111715620002f757620002f66200029b565b5b80604052505050565b60006200030c62000271565b90506200031a8282620002ca565b919050565b600067ffffffffffffffff8211156200033d576200033c6200029b565b5b602082029050602081019050919050565b600080fd5b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000620003858262000358565b9050919050565b620003978162000378565b8114620003a357600080fd5b50565b600081519050620003b7816200038c565b92915050565b600060408284031215620003d657620003d562000353565b5b620003e2604062000300565b90506000620003f484828501620003a6565b60008301525060206200040a84828501620003a6565b60208301525092915050565b60006200042d62000427846200031f565b62000300565b905080838252602082019050604084028301858111156200045357620004526200034e565b5b835b818110156200048057806200046b8882620003bd565b84526020840193505060408101905062000455565b5050509392505050565b600082601f830112620004a257620004a162000285565b5b8151620004b484826020860162000416565b91505092915050565b600060208284031215620004d657620004d56200027b565b5b600082015167ffffffffffffffff811115620004f757620004f662000280565b5b62000505848285016200048a565b91505092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b600082825260208201905092915050565b7f496e76616c696420617373657400000000000000000000000000000000000000600082015250565b600062000586600d836200053d565b915062000593826200054e565b602082019050919050565b60006020820190508181036000830152620005b98162000577565b9050919050565b7f496e76616c696420736f75726365000000000000000000000000000000000000600082015250565b6000620005f8600e836200053d565b91506200060582620005c0565b602082019050919050565b600060208201905081810360008301526200062b81620005e9565b9050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000819050919050565b6000620006788262000661565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8203620006ad57620006ac62000632565b5b600182019050919050565b61097380620006c86000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80631be5c92f1461003b578063b3596f0714610059575b600080fd5b610043610089565b604051610050919061040d565b60405180910390f35b610073600480360381019061006e919061048b565b61008e565b604051610080919061040d565b60405180910390f35b601281565b60008073ffffffffffffffffffffffffffffffffffffffff166000808473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff160361015c576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161015390610515565b60405180910390fd5b60006101678361018c565b905060006101808260200151836080015160ff16610343565b90508092505050919050565b6101946103b4565b60008060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1690508073ffffffffffffffffffffffffffffffffffffffff1663313ce5676040518163ffffffff1660e01b8152600401602060405180830381865afa92505050801561025f57506040513d601f19601f8201168201806040525081019061025c919061056e565b60015b610269575061033e565b80836080019060ff16908160ff1681525050508073ffffffffffffffffffffffffffffffffffffffff1663feaf968c6040518163ffffffff1660e01b815260040160a060405180830381865afa9250505080156102e457506040513d601f19601f820116820180604052508101906102e1919061063f565b60015b6102ee575061033e565b84876000019069ffffffffffffffffffff16908169ffffffffffffffffffff1681525050838760200181815250508187604001818152505060018760600190151590811515815250505050505050505b919050565b600080601283106103795760128361035b91906106e9565b600a6103679190610850565b8461037291906108ca565b90506103aa565b60128310156103a95782601261038f91906106e9565b600a61039b9190610850565b846103a691906108fb565b90505b5b8091505092915050565b6040518060a00160405280600069ffffffffffffffffffff1681526020016000815260200160008152602001600015158152602001600060ff1681525090565b6000819050919050565b610407816103f4565b82525050565b600060208201905061042260008301846103fe565b92915050565b600080fd5b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006104588261042d565b9050919050565b6104688161044d565b811461047357600080fd5b50565b6000813590506104858161045f565b92915050565b6000602082840312156104a1576104a0610428565b5b60006104af84828501610476565b91505092915050565b600082825260208201905092915050565b7f4173736574207072696365206665656420646f65736e27742065786973740000600082015250565b60006104ff601e836104b8565b915061050a826104c9565b602082019050919050565b6000602082019050818103600083015261052e816104f2565b9050919050565b600060ff82169050919050565b61054b81610535565b811461055657600080fd5b50565b60008151905061056881610542565b92915050565b60006020828403121561058457610583610428565b5b600061059284828501610559565b91505092915050565b600069ffffffffffffffffffff82169050919050565b6105ba8161059b565b81146105c557600080fd5b50565b6000815190506105d7816105b1565b92915050565b6000819050919050565b6105f0816105dd565b81146105fb57600080fd5b50565b60008151905061060d816105e7565b92915050565b61061c816103f4565b811461062757600080fd5b50565b60008151905061063981610613565b92915050565b600080600080600060a0868803121561065b5761065a610428565b5b6000610669888289016105c8565b955050602061067a888289016105fe565b945050604061068b8882890161062a565b935050606061069c8882890161062a565b92505060806106ad888289016105c8565b9150509295509295909350565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b60006106f4826103f4565b91506106ff836103f4565b9250828203905081811115610717576107166106ba565b5b92915050565b60008160011c9050919050565b6000808291508390505b6001851115610774578086048111156107505761074f6106ba565b5b600185161561075f5780820291505b808102905061076d8561071d565b9450610734565b94509492505050565b60008261078d5760019050610849565b8161079b5760009050610849565b81600181146107b157600281146107bb576107ea565b6001915050610849565b60ff8411156107cd576107cc6106ba565b5b8360020a9150848211156107e4576107e36106ba565b5b50610849565b5060208310610133831016604e8410600b841016171561081f5782820a90508381111561081a576108196106ba565b5b610849565b61082c848484600161072a565b92509050818404811115610843576108426106ba565b5b81810290505b9392505050565b600061085b826103f4565b9150610866836103f4565b92506108937fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff848461077d565b905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b60006108d5826103f4565b91506108e0836103f4565b9250826108f0576108ef61089b565b5b828204905092915050565b6000610906826103f4565b9150610911836103f4565b925082820261091f816103f4565b91508282048414831517610936576109356106ba565b5b509291505056fea264697066735822122026537522d2e0e14851f65b9c8be187d572692283b23f77140c544430cfa5580364736f6c63430008110033";

type FluxPriceFeedConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: FluxPriceFeedConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class FluxPriceFeed__factory extends ContractFactory {
  constructor(...args: FluxPriceFeedConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _config: FluxPriceFeed.ConfigStruct[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<FluxPriceFeed> {
    return super.deploy(_config, overrides || {}) as Promise<FluxPriceFeed>;
  }
  override getDeployTransaction(
    _config: FluxPriceFeed.ConfigStruct[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_config, overrides || {});
  }
  override attach(address: string): FluxPriceFeed {
    return super.attach(address) as FluxPriceFeed;
  }
  override connect(signer: Signer): FluxPriceFeed__factory {
    return super.connect(signer) as FluxPriceFeed__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): FluxPriceFeedInterface {
    return new utils.Interface(_abi) as FluxPriceFeedInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): FluxPriceFeed {
    return new Contract(address, _abi, signerOrProvider) as FluxPriceFeed;
  }
}
